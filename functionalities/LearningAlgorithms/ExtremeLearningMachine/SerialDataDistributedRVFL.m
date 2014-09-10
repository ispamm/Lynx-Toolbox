% SerialDataDistributedRVFL - 

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef SerialDataDistributedRVFL < DataDistributedLearningAlgorithm
    
    properties
    end
    
    methods
        
        function obj = SerialDataDistributedRVFL(model, varargin)
            obj = obj@DataDistributedLearningAlgorithm(model, varargin{:});
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
        
        function obj = train(obj, d)
            
            obj = obj.executeBeforeTraining(size(d.X.data, 2));
            d = d.generateSinglePartition(KFoldPartition(obj.topology.N));
            fprintf('\t\tEach node will have approximately %i patterns.\n', floor(size(d.X.data, 1)/obj.topology.N));
            
            N_hidden = obj.getParameter('hiddenNodes');
            N_nodes = obj.topology.N;         
            
            if(d.task == Tasks.MC)
                d.Y.data  = dummyvar(d.Y.data);
            end
            
            beta = zeros(N_hidden, N_nodes);
            
            if(strcmp(obj.getParameter('train_algo'), 'consensus'))
              
                for ii = 1:N_nodes
                    
                    [~, d_local] = d.getFold(ii);
                    Xtr = d_local.X.data;
                    Ytr = d_local.Y.data;
                    [N, ~] = size(Xtr);
                    
                    H = obj.model.computeHiddenMatrix(Xtr);
                    if(N >= N_hidden)
                        beta(:, ii) = (eye(N_hidden)./obj.parameters.C + H' * H) \ ( H' * Ytr );
                    else
                        beta(:, ii) = H'*inv(eye(size(H, 1))./obj.parameters.C + H * H') *  Ytr ;
                    end
                    clear H
            
                end
                
                % Execute (serial) consensus algorithm
                if(obj.getParameter('consensus_max_steps') > 0)
                    [obj.model.outputWeights, obj.statistics.consensus_error] = ...
                        obj.run_consensus_serial(beta, obj.getParameter('consensus_max_steps'), obj.getParameter('consensus_thres'));
                else
                    obj.model.outputWeights = beta(:, 1);
                end
                    
            
            else
               
                % Get the logger
                s = SimulationLogger.getInstance();
                
                % Global term
                z = zeros(N_hidden, 1);
                
                % Lagrange multipliers
                t = zeros(N_hidden, N_nodes);
                
                % Parameters
                rho = obj.getParameter('admm_rho');
                steps = obj.getParameter('admm_max_steps');
                
                % Statistics initialization
                obj.statistics.r_norm = zeros(steps, 1);
                obj.statistics.s_norm = zeros(steps, 1);
                obj.statistics.eps_pri = zeros(steps, 1);
                obj.statistics.eps_dual = zeros(steps, 1);
                
                % Precompute the inverse matrices
                Hinv = cell(N_nodes, 1);
                HY = cell(N_nodes, 1);
                for ii = 1:N_nodes
                    
                    [~, d_local] = d.getFold(ii);
                    Xtr = d_local.X.data;
                    Hinv{ii} = obj.model.computeHiddenMatrix(Xtr);
                    HY{ii} = Hinv{ii}'*d_local.Y.data;
                    Hinv{ii} = inv(eye(N_hidden)*rho + Hinv{ii}' * Hinv{ii});
            
                end

                beta = zeros(N_hidden, N_nodes);
                
                for ii = 1:steps

                    for jj = 1:N_nodes
                    
                        % Compute current weights
                        beta(:, jj) = Hinv{jj}*(HY{jj} + rho*z - t(:, jj));
                    
                    end
                    
                    % Run consensus
                    beta_avg = ...
                        obj.run_consensus_serial(beta, obj.getParameter('consensus_max_steps'), obj.getParameter('consensus_thres'));
                    t_avg = obj.run_consensus_serial(t, obj.getParameter('consensus_max_steps'), obj.getParameter('consensus_thres'));
                    
                    % Store the old z and update it
                    zold = z;
                    z = (rho*beta_avg + t_avg)/(obj.getParameter('C') + rho);

                    % Compute the update for the Lagrangian multipliers
                    for jj = 1:N_nodes
                        t(:, jj) = t(:, jj) + rho*(beta(:, jj) - z);
                    end
                    
                    % Compute primal and dual residuals
                    for jj = 1:N_nodes
                        obj.statistics.r_norm(ii) = obj.statistics.r_norm(ii) + ...
                            norm(beta(:, jj) - z);
                        % Compute epsilon values
                        obj.statistics.eps_pri(ii) = obj.statistics.eps_pri(ii) + ...
                            sqrt(N_nodes)*obj.getParameter('admm_abstol') + ...
                            obj.getParameter('admm_reltol')*max(norm(beta(:, jj)), norm(z));
                        obj.statistics.eps_dual(ii)= obj.statistics.eps_dual(ii) + ...
                            sqrt(N_nodes)*obj.getParameter('admm_abstol') + ...
                            obj.getParameter('admm_reltol')*norm(t(:, jj));
                    end
                    
                    obj.statistics.r_norm(ii) = obj.statistics.r_norm(ii)/N_nodes;
                    obj.statistics.eps_pri(ii) = obj.statistics.eps_pri(ii)/N_nodes;
                    obj.statistics.eps_dual(ii) = obj.statistics.eps_dual(ii)/N_nodes;
                    obj.statistics.s_norm(ii) = norm(-rho*(z - zold));
                    
                    if(s.flags.debug && mod(ii, 10) == 0)
                        fprintf('\t\tADMM iteration #%i: primal residual = %.2f, dual_residual = %.2f.\n', ...
                            ii, obj.statistics.r_norm(ii), obj.statistics.s_norm(ii));
                    end
                    
                    if(obj.statistics.r_norm(ii) < obj.statistics.eps_pri(ii) && ...
                            obj.statistics.s_norm(ii) < obj.statistics.eps_dual(ii))
                        break;
                    end

                end
                
                obj.model.outputWeights = beta(:, 1);

            end
            
            obj.obj_locals{1} = obj;
        end
        
        function obj = train_locally(obj, ~)
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

