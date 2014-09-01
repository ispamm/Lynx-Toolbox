% MultiLabelTask - A classification task with multiple binary labels
%   This requires inside the .mat file: (i) a Nxd matrix of inputs,
%   where N is the number of samples and d the dimensionality of every
%   input; (ii) a NxT matrix of outputs, where each column corresponds
%   to a specific binary classification task; (iii) an info string
%   describing the dataset; a labels_info cell array of string
%   describing each label.

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
            obj.dataset_factory = BinaryRelevanceFactory();
            obj = obj.addFolder('datasets/ML');
        end
    end
    
    methods (Static)
        function singleObj = getInstance()
            singleObj = SingletonClass.getInstanceFromClass(MultiLabelTask());
        end
    end
    
    methods
        
        function obj = checkForConsistency(obj, o, name)
            obj.checkForConsistency@BasicTask(o, name);
            assert((size(o.Y, 1) == size(o.X, 1)) == 1, 'Lynx:Initialization:InvalidDataset', sprintf('Size of the matrices for dataset %s is not consistent', name));
            assert(all(all(abs(o.Y) == 1)), 'Lynx:Initialization:InvalidDataset', sprintf('Output matrix for dataset %s must contain columns of -1 or +1', name));
        end
        
        function s = getDescription(obj)
            s = 'Multilabel classification';
        end
        
        function id = getTaskId(obj)
            id = Tasks.ML;
        end
        
    end
    
end

