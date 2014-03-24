classdef KFoldPartition < PartitionStrategy
    
    %KFOLDPARTITION Represents a k-fold cross-validation partition. This
    %partitions the data into k distinct folds of equal size, and return
    %the i-th fold as test samples each time.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    properties
        k;                  % Number of folds
        partition_struct;   % cvpartition object to compute and hold the indexes
    end
    
    methods
        function obj = KFoldPartition(k)
            obj.k = k;
            obj.num_folds = k;
        end
        
        function obj = partition(obj, Y)
            warning('off', 'stats:cvpartition:KFoldMissingGrp');
            obj.partition_struct = cvpartition(Y, 'kfold', obj.k);
            warning('on', 'stats:cvpartition:KFoldMissingGrp');
            obj = obj.setCurrentFold(1);
        end
            
        function trainIndexes = getTrainingIndexes(obj)
            trainIndexes = obj.partition_struct.training(obj.current_fold);
        end
        
        function testIndexes = getTestIndexes(obj)
            testIndexes = obj.partition_struct.test(obj.current_fold);
        end
    end
    
end

