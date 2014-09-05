% DataDistributedRVFL - 

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef DataDistributedRVFL < DataDistributedLearningAlgorithm
    
    properties
    end
    
    methods
        
        function obj = DataDistributedRVFL(model, varargin)
            obj = obj@DataDistributedLearningAlgorithm(model, varargin{:});
        end
        
        function p = initParameters(~, p)
            p.addParamValue('C', 1, @(x) assert(x > 0, 'Regularization parameter of DataDistributedRVFL must be > 0'));
            p.addParamValue('train_algo', 'consensus', @(x) assert(isingroup(x, {'consensus', 'admm'}), ...
                'Lynx:Runtime:Validation', 'The train_algo of DataDistributedRVFL can be: consensus, admm'));
            p.addParamValue('consensus_max_steps', 10);
            p.addParamValue('consensus_thres', 0.01);
            p.addParamValue('admm_max_steps', 10);
            p.addParamValue('admm_rho', 0.1);
        end
        
        function obj = train_locally(obj, Xtr, Ytr)
            
            [N, d] = size(Xtr);
            N_hidden = obj.getParameter('hiddenNodes');
            
            if(obj.getCurrentTask() == Tasks.MC)
                Ytr  = dummyvar(Ytr);
            end
            
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
                        obj.run_consensus(@() obj.model.outputWeights, obj.getParameter('consensus_max_steps'), obj.getParameter('consensus_thres'));
                end
            
            else
               
                z = zeros(N_hidden, 1);
                u = zeros(N_hidden, 1);
                
                if(N >= N_hidden)
                    Hinv = inv(eye(N_hidden)./obj.parameters.C + H' * H);
                else
                    Hinv = inv(eye(size(H, 1))./obj.parameters.C + H * H');
                end
                
                rho = obj.getParameter('admm_rho');
                
                for jj = 1:obj.getParameter('admm_max_steps')

                    
                    if(N >= N_hidden)
                        obj.model.outputWeights = Hinv*(H'*Ytr + rho*(z + u));
                    else
                        obj.model.outputWeights = H'*Hinv*(Ytr + rho*(z + u));
                    end
                    
                    beta_avg = ...
                        obj.run_consensus(@() obj.model.outputWeights, obj.getParameter('consensus_max_steps'), obj.getParameter('consensus_thres'));
                    u_avg = obj.run_consensus(@() u, obj.getParameter('consensus_max_steps'), obj.getParameter('consensus_thres'));
                    
                    z = ((N*rho)/(obj.getParameter('C') + N*rho))*(beta_avg + u_avg);
                    u = u + obj.model.outputWeights - z;
                    
                end
                
            end
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

