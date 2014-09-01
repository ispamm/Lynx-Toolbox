% BinaryClassificationTask - A binary classification task
%   A binary classification task is the task of associating to every input
%   element a value in {-1, +1}.
%
%   This requires inside the .mat file: 
%
%       (i) a Nxd matrix of inputs, where N is the number of samples and d 
%           the dimensionality of every input
%       (ii) a Nx1 vector of outputs, where each element can be -1 or +1
%       (iii) an info string describing the dataset.

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
            obj.dataset_factory = DummyDatasetFactory();
            obj = obj.addFolder('datasets/BC');
        end
    end
    
    methods (Static)
      function singleObj = getInstance()
         singleObj = SingletonClass.getInstanceFromClass(BinaryClassificationTask());
      end
    end
    
    methods
        
        function obj = checkForConsistency(obj, o, name)
            obj.checkForConsistency@BasicTask(o, name);
            assert((size(o.Y, 1) == size(o.X, 1)) && size(o.Y,2) == 1, 'Lynx:Initialization:InvalidDataset', sprintf('Size of the matrices for dataset %s is not consistent', name));
            assert(all(abs(o.Y) == 1), 'Lynx:Initialization:InvalidDataset', sprintf('Output matrix for dataset %s must contain only -1 or +1', name));
        end
        
        function s = getDescription(obj)
            s = 'Binary classification';
        end
        
        function id = getTaskId(obj)
            id = Tasks.BC;
        end

    end
  
end

