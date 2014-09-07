% RegressionTask - A regression task
%   This requires that the output is a RealLabelsVector.

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
            obj = obj.addFolder('datasets/R');
        end
    end
    
    methods (Static)
      function singleObj = getInstance()
         singleObj = SingletonClass.getInstanceFromClass(RegressionTask());
      end
    end
    
    methods

        function obj = checkForConsistency(obj, d)
            assert(isa(d.Y), 'RealLabelsVector', 'Lynx:Validation:InvalidDataset', 'Output for dataset %s must be a real vector', d.name);
        end
        
        function s = getDescription(obj)
            s = 'Regression';
        end
        
        function id = getTaskId(obj)
            id = Tasks.R;
        end
        
        function datatype = getDataType(obj, y)
            datatype = RealLabelsVector(y);
        end

    end
  
end

