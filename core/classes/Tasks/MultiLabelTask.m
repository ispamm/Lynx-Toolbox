% MultiLabelTask - A classification task with multiple binary labels
%   This requires that the output value is a MultiLabelMatrix.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef MultiLabelTask < BasicTask
    
    properties(Access=protected,Constant)
        singleton_id = 'multilabel_task_obj';
    end
    
    methods(Access=protected)
        function obj = MultiLabelTask()
            obj = obj@BasicTask();
            obj.performance_measure = [];
            obj = obj.addFolder('datasets/ML');
        end
    end
    
    methods (Static)
        function singleObj = getInstance()
            singleObj = SingletonClass.getInstanceFromClass(MultiLabelTask());
        end
    end
    
    methods
        
        function obj = checkForConsistency(obj, d)
            assert(isa(d.Y), 'MultiLabelMatrix', 'Lynx:Validation:InvalidDataset', 'Output for dataset %s must be a multi-label matrix', d.name);
        end
        
        function s = getDescription(obj)
            s = 'Multilabel classification';
        end
        
        function id = getTaskId(obj)
            id = Tasks.ML;
        end
        
    end
    
end

