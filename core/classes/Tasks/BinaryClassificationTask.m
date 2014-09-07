% BinaryClassificationTask - A binary classification task
%   A binary classification task is the task of associating to every input
%   element a value in {-1, +1}.
%
%   This requires that the output is a BinaryLabelsVector.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef BinaryClassificationTask < BasicTask
    
    properties(Access=protected,Constant)
        singleton_id = 'binary_task_obj';
    end
    
    methods(Access=protected)
        function obj = BinaryClassificationTask()
            obj = obj@BasicTask();
            obj.performance_measure = MisclassificationError();
            obj = obj.addFolder('datasets/BC');
        end
    end
    
    methods (Static)
      function singleObj = getInstance()
         singleObj = SingletonClass.getInstanceFromClass(BinaryClassificationTask());
      end
    end
    
    methods
        
        function obj = checkForConsistency(obj, d)
            assert(isa(d.Y), 'BinaryLabelsVector', 'Lynx:Validation:InvalidDataset', 'Output for dataset %s must be a binary vector', d.name);
        end
        
        function s = getDescription(obj)
            s = 'Binary classification';
        end
        
        function id = getTaskId(obj)
            id = Tasks.BC;
        end

    end
  
end

