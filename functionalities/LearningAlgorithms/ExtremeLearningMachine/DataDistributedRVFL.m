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
            p.addParamValue('consensus_steps', 10);
        end
        
        function obj = train_locally(obj, Xtr, Ytr)
            % Train on the nodes
            r = RegularizedELM(obj.model, 'C', obj.parameters.C);
            r = r.train(Xtr, Ytr);
            obj.model = r.model;

            % Execute consensus algorithm
            for ii = 1:obj.getParameter('consensus_steps')
               labBarrier;
               idx = obj.getNeighbors(labindex);
               for jj = 1:length(idx)
                   w = labSendReceive(idx(jj), idx(jj), obj.model.outputWeights);
                   obj.model.outputWeights = obj.model.outputWeights + w;
               end
               obj.model.outputWeights = obj.model.outputWeights./(length(idx) + 1);
            end
            
        end
        
        function obj = executeBeforeTraining(obj, Xtr, ~)
            obj.model = obj.model.generateWeights(size(Xtr, 2));
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

