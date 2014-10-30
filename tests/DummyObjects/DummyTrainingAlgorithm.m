classdef DummyTrainingAlgorithm < LearningAlgorithm
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    properties
    end
    
    methods
        
        function obj = DummyTrainingAlgorithm(model, varargin)
            obj = obj@LearningAlgorithm(model, varargin{:});
            obj.model = model;
        end
        
        function p = initParameters(~, p)
        end
        
        function obj = train(obj, d)
            obj.model.internalParameter  = mean(d.Y.data);
        end
        
        function res = isTaskAllowed(~, ~)
            res = true;
        end

        function b = checkForCompatibility(~, model)
            b = model.isOfClass('DummyModel');
        end

    end
    
    methods(Static)
        
        function info = getDescription()
            info = 'Dummytrainingalgorithm';
        end

    end
    
end

