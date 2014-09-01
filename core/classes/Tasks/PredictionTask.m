% PredictionTask - A prediction task
%   This requires inside the .mat file: (i) a Nx1 vector with the
%   values of an univariate time-series; (iii) an info string
%   describing the dataset.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef PredictionTask < BasicTask
    
    properties(Access=protected,Constant)
        singleton_id = 'prediction_task_obj';
    end
    
    methods(Access=protected)
        function obj = PredictionTask()
            obj = obj@BasicTask();
            obj.performance_measure = [];
            obj.dataset_factory = EmbedTimeseriesFactory(7, 1);
            obj = obj.addFolder('datasets/PR');
        end
    end
    
    methods (Static)
        function singleObj = getInstance()
            singleObj = SingletonClass.getInstanceFromClass(PredictionTask());
        end
    end
    
    methods
        
        function obj = checkForConsistency(obj, o, name)
            assert(isfield(o, 'X'), 'Lynx:Initialization:InvalidDataset', sprintf('The dataset %s does not contain an input vector X', name));
            assert(isfield(o, 'info'), 'Lynx:Initialization:InvalidDataset', sprintf('The dataset %s does not contain a descriptive string ''info''', name));
            assert(isnumeric(o.X), 'Lynx:Initialization:InvalidDataset', sprintf('The input matrix X for dataset %s is not valid', name));
            assert(size(o.X,2) == 1, 'Lynx:Initialization:InvalidDataset', sprintf('The input X for dataset %s must be a vector', name));
        end
        
        function s = getDescription(obj)
            s = 'Prediction';
        end
        
        function id = getTaskId(obj)
            id = Tasks.PR;
        end
        
    end
    
end

