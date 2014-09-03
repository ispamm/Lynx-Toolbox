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
        end
        
        function obj = train_locally(obj, Xtr, Ytr)
            r = RegularizedELM(obj.model, 'C', obj.parameteters.C);
            r = r.train(Xtr, Ytr);
            obj.model = r.model;
        end

        function b = checkForCompatibility(~, model)
            b = model.isOfClass('ExtremeLearningMachine');
        end
    end
    
    methods(Static)

        function info = getDescription()
            info = [''];
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

