% DataDistributedRVFL - Parallel version of SerialDataDistributedRVFL
%   Refer to the following link for more information:
%   http://ispac.ing.uniroma1.it/scardapane/software/lynx/dist-learning/

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef DataDistributedRVFL < DistributedLearningAlgorithm
    
    properties
    end
    
    methods
        
        function obj = DataDistributedRVFL(model, varargin)
            obj = obj@DistributedLearningAlgorithm(model, varargin{:});
        end
        
        function p = initParameters(~, p)
            p.addParamValue('C', 1, @(x) assert(x > 0, 'Regularization parameter of DataDistributedRVFL must be > 0'));
            p.addParamValue('train_algo', 'consensus', @(x) assert(isingroup(x, {'consensus', 'admm'}), ...
                'Lynx:Runtime:Validation', 'The train_algo of DataDistributedRVFL can be: consensus, admm'));
            p.addParamValue('consensus_max_steps', 10);
            p.addParamValue('consensus_thres', 0.01);
            p.addParamValue('admm_max_steps', 10);
            p.addParamValue('admm_rho', 1);
            p.addParamValue('admm_reltol', 0.001);
            p.addParamValue('admm_abstol', 0.001);
        end
        
        function obj = train_locally(obj, d)
            
            % Get training data
            Xtr = d.X.data;
            Ytr = d.Y.data;

            [N, ~] = size(Xtr);
            N_hidden = obj.getParameter('hiddenNodes');

            H = obj.model.computeHiddenMatrix(Xtr);
            
            if(strcmp(obj.getParameter('train_algo'), 'consensus'))
                
                if(N >= N_hidden)
                    obj.model.outputWeights = (eye(N_hidden)./obj.parameters.C + H' * H) \ ( H' * Ytr );
                else
                    obj.model.outputWeights = H'*inv(eye(size(H, 1))./obj.parameters.C + H * H') *  Ytr ;
                end
                clear H
            
                % Execute consensus algorithm
                if(obj.getParameter('consensus_max_steps') > 0)
                    [obj.model.outputWeights, obj.statistics.consensus_error] = ...
                        obj.run_consensus(obj.model.outputWeights, obj.getParameter('consensus_max_steps'), obj.getParameter('consensus_thres'));
                end
            
            else
               
                % Global term
                z = zeros(N_hidden, 1);
                
                % Lagrange multipliers
                t = zeros(N_hidden, 1);
                
                % Parameters
                rho = obj.getParameter('admm_rho');
                N_nodes = matlabpool('size');
                steps = obj.getParameter('admm_max_steps');
                
                % Statistics initialization
                obj.statistics.r_norm = zeros(steps, 1);
                obj.statistics.s_norm = zeros(steps, 1);
                obj.statistics.eps_pri = zeros(steps, 1);
                obj.statistics.eps_dual = zeros(steps, 1);
                
                % Precompute the inverse matrix
                Hinv = inv(eye(N_hidden)*rho + obj.getParameter('C') * H' * H);

                for jj = 1:steps
                    
                    % Compute current weights
                    obj.model.outputWeights = Hinv*(obj.getParameter('C')*H'*Ytr + rho*z - t);
                    
                    % Run consensus
                    beta_avg = ...
                        obj.run_consensus(obj.model.outputWeights, obj.getParameter('consensus_max_steps'), obj.getParameter('consensus_thres'));
                    t_avg = obj.run_consensus(t, obj.getParameter('consensus_max_steps'), obj.getParameter('consensus_thres'));
                    
                    % Store the old z and update it
                    zold = z;
                    z = (rho*beta_avg + t_avg)/(1 + rho);

                    % Compute the update for the Lagrangian multipliers
                    t = t + rho*(obj.model.outputWeights - z);
                    
                    % Compute primal and dual residuals
                    obj.statistics.r_norm(jj) = norm(obj.model.outputWeights - z);
                    obj.statistics.s_norm(jj) = norm(-rho*(z - zold));

                    % Compute epsilon values
                    obj.statistics.eps_pri(jj) = sqrt(N_nodes)*obj.getParameter('admm_abstol') + ...
                        obj.getParameter('admm_reltol')*max(norm(obj.model.outputWeights), norm(z));
                    obj.statistics.eps_dual(jj)= sqrt(N_nodes)*obj.getParameter('admm_abstol') + ...
                        obj.getParameter('admm_reltol')*norm(t);

                end
                
            end
        end
        
        function obj = executeBeforeTraining(obj, d)
            obj.model = obj.model.generateWeights(d);
        end
        
        function b = checkForCompatibility(~, model)
            b = model.isOfClass('RandomVectorFunctionalLink') && (model.task == Tasks.R || model.task == Tasks.BC);
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

