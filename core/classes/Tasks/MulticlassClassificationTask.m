% MulticlassClassificationTask - A multi-class classification task
%   This requires that the output is a IntegerLabelsVector.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef MulticlassClassificationTask < BasicTask
    
    properties(Access=protected,Constant)
        singleton_id = 'multiclass_task_obj';
    end
    
    methods(Access=protected)
        function obj = MulticlassClassificationTask()
            obj = obj@BasicTask();
            obj.performance_measure = MisclassificationError();
            obj = obj.addFolder('datasets/MC');
        end
    end
    
    methods (Static)
        function singleObj = getInstance()
            singleObj = SingletonClass.getInstanceFromClass(MulticlassClassificationTask());
        end
    end
    
    methods
        
        function obj = checkForConsistency(obj, d)
            assert(isa(d.Y), 'IntegerLabelsVector', 'Lynx:Validation:InvalidDataset', 'Output for dataset %s must be an integer vector', d.name);
        end
        
        function s = getDescription(obj)
            s = 'Multiclass classification';
        end
        
        function id = getTaskId(obj)
            id = Tasks.MC;
        end
        
    end
    
end

