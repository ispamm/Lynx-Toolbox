% BaselineTrainingAlgorithm - Baseline learning algorithm
%   See BaselineModel for information

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef BaselineTrainingAlgorithm < LearningAlgorithm

    properties
    end
    
    methods
        
        function obj = BaselineTrainingAlgorithm(model, varargin)
            obj = obj@LearningAlgorithm(model, varargin{:});
            obj.model = model;
        end
        
        function p = initParameters(~, p)
        end
        
        function obj = train(obj, d)
            
            % Get training data
            Ytr = d.Y.data;
            
            if(d.task == Tasks.R)
                obj.model.avValue  = mean(Ytr);
            else
                [obj.model.distribution, obj.model.values] = hist(Ytr, unique(Ytr));
                obj.model.distribution = obj.model.distribution./norm(obj.model.distribution,1);
            end
        end

        function b = checkForCompatibility(~, model)
            b = model.isOfClass('BaselineModel');
        end

    end
    
    methods(Static)
        
        function info = getDescription()
            info = ['Dummy learning algorithm, should be used only as a baseline for error rates. ' ...
                'For regression tasks, it always returns the average values of the input data in the training set. ' ...
                'For classification, it returns random labels in the same proportions as the input data.'];
        end

    end
    
end

