% SerialDataDistributedRVFL - 

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef SerialDataDistributedRVFL < DistributedLearningAlgorithm
    
    properties
    end
    
    methods
        
        function obj = SerialDataDistributedRVFL(model, varargin)
            obj = obj@DistributedLearningAlgorithm(model, varargin{:});
        end
        
        function p = initParameters(~, p)
            p.addParamValue('C', 1, @(x) assert(x > 0, 'Regularization parameter of SerialDataDistributedRVFL must be > 0'));
            p.addParamValue('train_algo', 'consensus', @(x) assert(isingroup(x, {'consensus', 'admm'}), ...
                'Lynx:Runtime:Validation', 'The train_algo of SerialDataDistributedRVFL can be: consensus, admm'));
            p.addParamValue('consensus_max_steps', 10);
            p.addParamValue('consensus_thres', 0.01);
            p.addParamValue('admm_max_steps', 10);
            p.addParamValue('admm_rho', 1);
            p.addParamValue('admm_reltol', 0.001);
            p.addParamValue('admm_abstol', 0.001);
        end
        
        function obj = train_locally(obj, d)
            
            N_hidden = obj.getParameter('hiddenNodes');
            N_nodes = obj.topology.N;         
            is_multiclass = d.task == Tasks.MC;
            
            if(is_multiclass)
                nLabels = max(d.Y.data);
                beta = zeros(N_hidden, nLabels, N_nodes);
            else
                beta = zeros(N_hidden, N_nodes);
            end
            
            if(strcmp(obj.getParameter('train_algo'), 'consensus'))
              
                for ii = 1:N_nodes
                    
                    d_local = obj.getLocalPart(d, ii);
                    
                    Xtr = d_local.X.data;
                    if(is_multiclass)
                        Ytr = dummyvar(d_local.Y.data);
                    else
                        Ytr = d_local.Y.data;
                    end
                    [N, ~] = size(Xtr);
                    
                    H = obj.model.computeHiddenMatrix(Xtr);
                    
                    if(N >= N_hidden)
                        out = (eye(N_hidden)*obj.parameters.C + H' * H) \ ( H' * Ytr );
                    else
                        out = H'*inv(eye(size(H, 1))*obj.parameters.C + H * H') *  Ytr ;
                    end
                    
                    if(is_multiclass)
                        beta(:,:,ii) = out;
                    else
                        beta(:,ii) = out;
                    end
                    
                    clear H
            
                end
                
                % Execute (serial) consensus algorithm
                if(obj.getParameter('consensus_max_steps') > 0)
                    [obj.model.outputWeights, obj.statistics.consensus_error] = ...
                        obj.run_consensus_serial(beta, obj.getParameter('consensus_max_steps'), obj.getParameter('consensus_thres'));
                else
                    if(is_multiclass)
                        obj.model.outputWeights = beta(:, :, 1);
                    else
                        obj.model.outputWeights = beta(:, 1);
                    end
                end
                    
            
            else
               
                % Get the logger
                s = SimulationLogger.getInstance();
                
                % Global term
                if(is_multiclass)
                    z = zeros(N_hidden, nLabels);
                else
                    z = zeros(N_hidden, 1);
                end
                
                % Lagrange multipliers
                if(is_multiclass)
                    t = zeros(N_hidden, nLabels, N_nodes);
                else
                    t = zeros(N_hidden, N_nodes);
                end
                
                % Parameters
                rho = obj.getParameter('admm_rho');
                steps = obj.getParameter('admm_max_steps');
                
                % Statistics initialization
                obj.statistics.r_norm = zeros(steps, 1);
                obj.statistics.s_norm = zeros(steps, 1);
                obj.statistics.eps_pri = zeros(steps, 1);
                obj.statistics.eps_dual = zeros(steps, 1);
                obj.statistics.consensus_steps = zeros(steps, 1);
                
                % Precompute the inverse matrices
                Hinv = cell(N_nodes, 1);
                HY = cell(N_nodes, 1);
                
                for ii = 1:N_nodes
                    
                    d_local = obj.getLocalPart(d, ii);
                    Xtr = d_local.X.data;
                    
                    Hinv{ii} = obj.model.computeHiddenMatrix(Xtr);
                    
                    if(is_multiclass)
                        HY{ii} = Hinv{ii}'*dummyvar(d_local.Y.data);
                    else
                        HY{ii} = Hinv{ii}'*d_local.Y.data;
                    end
                    Hinv{ii} = inv(eye(N_hidden)*rho + Hinv{ii}' * Hinv{ii});
                    
                end

                if(is_multiclass)
                    beta = zeros(N_hidden, nLabels, N_nodes);
                else
                    beta = zeros(N_hidden, N_nodes);
                end
                
                for ii = 1:steps

                    for jj = 1:N_nodes
                    
                        % Compute current weights
                        if(is_multiclass)
                            beta(:, :, jj) = Hinv{jj}*(HY{jj} + rho*z - t(:, :, jj));
                        else
                            beta(:, jj) = Hinv{jj}*(HY{jj} + rho*z - t(:, jj));
                        end
                    
                    end
                    
                    % Run consensus
                    [beta_avg, tmp1] = ...
                        obj.run_consensus_serial(beta, obj.getParameter('consensus_max_steps'), obj.getParameter('consensus_thres'));
                    [t_avg, tmp2] = obj.run_consensus_serial(t, obj.getParameter('consensus_max_steps'), obj.getParameter('consensus_thres'));
                    
                    % Save statistic
                    obj.statistics.consensus_steps(ii) = max(sum(tmp1 ~= 0), sum(tmp2 ~=0));
                    
                    % Store the old z and update it
                    zold = z;
                    z = (rho*beta_avg + t_avg)/(obj.getParameter('C') + rho);

                    % Compute the update for the Lagrangian multipliers
                    for jj = 1:N_nodes
                        if(is_multiclass)
                            t(:, :, jj) = t(:, :, jj) + rho*(beta(:, :, jj) - z);
                        else
                            t(:, jj) = t(:, jj) + rho*(beta(:, jj) - z);
                        end
                    end
                    
                    % Compute primal and dual residuals
                    for jj = 1:N_nodes
                        if(is_multiclass)
                            newbeta = beta(:, :, jj);
                            newt = t(:, :, jj);
                        else
                            newbeta = beta(:, jj);
                            newt = t(:, jj);
                        end
                        obj.statistics.r_norm(ii) = obj.statistics.r_norm(ii) + ...
                            norm(newbeta - z, 'fro');
                        % Compute epsilon values
                        obj.statistics.eps_pri(ii) = obj.statistics.eps_pri(ii) + ...
                            sqrt(N_nodes)*obj.getParameter('admm_abstol') + ...
                            obj.getParameter('admm_reltol')*max(norm(newbeta, 'fro'), norm(z, 'fro'));
                        
                        obj.statistics.eps_dual(ii)= obj.statistics.eps_dual(ii) + ...
                            sqrt(N_nodes)*obj.getParameter('admm_abstol') + ...
                            obj.getParameter('admm_reltol')*norm(newt, 'fro');
                    end
                    
                    obj.statistics.r_norm(ii) = obj.statistics.r_norm(ii)/N_nodes;
                    obj.statistics.eps_pri(ii) = obj.statistics.eps_pri(ii)/N_nodes;
                    obj.statistics.eps_dual(ii) = obj.statistics.eps_dual(ii)/N_nodes;
                    obj.statistics.s_norm(ii) = norm(-rho*(z - zold), 'fro');
                    
                    if(s.flags.debug && mod(ii, 10) == 0)
                        fprintf('\t\tADMM iteration #%i: primal residual = %.2f, dual_residual = %.2f.\n', ...
                            ii, obj.statistics.r_norm(ii), obj.statistics.s_norm(ii));
                    end
                    
                    if(obj.statistics.r_norm(ii) < obj.statistics.eps_pri(ii) && ...
                            obj.statistics.s_norm(ii) < obj.statistics.eps_dual(ii))
                        break;
                    end

                end
                
                if(is_multiclass)
                    obj.model.outputWeights = beta(:, :, 1);
                else
                    obj.model.outputWeights = beta(:, 1);
                end

            end
            
            obj.obj_locals{1} = obj;
        end

        function obj = executeBeforeTraining(obj, d)
            obj.model = obj.model.generateWeights(d);
        end
        
        function b = checkForCompatibility(~, model)
            b = model.isOfClass('ExtremeLearningMachine');
        end
    end
    
    methods(Static)

        function info = getDescription()
            info = ['Data-distributed RVFL'];
        end
        
        function pNames = getParametersNames()
            pNames = {'C'}; 
        end
        
        function pInfo = getParametersDescription()
            pInfo = {'Regularization factor'};
        end
        
        function pRange = getParametersRange()
            pRange = {'Positive real number, default is 1'};
        end    
    end
    
end

