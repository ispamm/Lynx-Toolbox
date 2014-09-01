% MulticlassClassificationTask - A multi-class classification task
%   This requires inside the .mat file: (i) a Nxd matrix of inputs,
%   where N is the number of samples and d the dimensionality of every
%   input; (ii) a Nx1 vector of outputs, where each element can be
%   1,...,M, where M is the number of classes; (iii) an info string
%   describing the dataset.

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
            obj.dataset_factory = DummyDatasetFactory();
            obj = obj.addFolder('datasets/MC');
        end
    end
    
    methods (Static)
        function singleObj = getInstance()
            singleObj = SingletonClass.getInstanceFromClass(MulticlassClassificationTask());
        end
    end
    
    methods
        
        function obj = checkForConsistency(obj, o, name)
            obj.checkForConsistency@BasicTask(o, name);
            assert((size(o.Y, 1) == size(o.X, 1)) && size(o.Y,2) == 1, 'Lynx:Initialization:InvalidDataset', sprintf('Size of the matrices for dataset %s is not consistent', name));
            b = arrayfun(@(x)isnatural(x,true), o.Y);
            assert(all(b == true), 'Lynx:Initialization:InvalidDataset', sprintf('Output matrix for dataset %s must contain only integers from 1 to M', name));
        end
        
        function s = getDescription(obj)
            s = 'Multiclass classification';
        end
        
        function id = getTaskId(obj)
            id = Tasks.MC;
        end
        
    end
    
end

