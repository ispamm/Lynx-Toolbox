% RegressionTask - A regression task
%   This requires inside the .mat file: (i) a Nxd matrix of inputs,
%   where N is the number of samples and d the dimensionality of every
%   input; (ii) a Nx1 vector of outputs, where each element can be a
%   real number; (iii) an info string describing the dataset.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef RegressionTask < BasicTask
    
    properties(Access=protected,Constant)
        singleton_id = 'regression_task_obj';
    end
    
    methods(Access=protected)
        function obj = RegressionTask()
            obj = obj@BasicTask();
            obj.performance_measure = MeanSquaredError();
            obj.dataset_factory = DummyDatasetFactory();
            obj = obj.addFolder('datasets/R');
        end
    end
    
    methods (Static)
      function singleObj = getInstance()
         singleObj = SingletonClass.getInstanceFromClass(RegressionTask());
      end
    end
    
    methods

        function obj = checkForConsistency(obj, o, name)
            obj.checkForConsistency@BasicTask(o, name);
            assert((size(o.Y, 1) == size(o.X, 1)) && size(o.Y,2) == 1, 'Lynx:Initialization:InvalidDataset', sprintf('Size of the matrices for dataset %s is not consistent', name));
        end
        
        function s = getDescription(obj)
            s = 'Regression';
        end
        
        function id = getTaskId(obj)
            id = Tasks.R;
        end

    end
  
end

