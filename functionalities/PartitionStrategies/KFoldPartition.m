% KFoldPartition - K-Fold Cross-Validation partitioning
%   A KFoldPartition generates a k-fold cross-validation partition of
%   the dataset. For a given K, this results in K different folds. The
%   dataset is partitioned into K subset, and the i-th fold contains
%   the i-th subset as test and the other K-1 as training. Typical
%   values of K are between 3 and 10.
%
%   Example:
%
%   p = KFoldPartition(3) - Create a 3-fold cross-validation partition
%
%   See also: PartitionStrategy

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef KFoldPartition < PartitionStrategy
    
    properties
        k;                  % Number of folds
        partition_struct;   % cvpartition object to compute and hold the indexes
    end
    
    methods
        function obj = KFoldPartition(k)
            % Create a KFoldPartition object. The parameter k must be a
            % natural number.
            assert(isnatural(k, true), 'Lynx:Validation:InvalidInput', 'The number of partitions in k-fold must be a natural number');
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
        
        function s = getFoldInformation(obj)
            s = sprintf('Using k-fold partition %i of %i... (%i training samples, %i testing samples)\n', obj.current_fold, obj.num_folds, sum(obj.partition_struct.training(obj.current_fold)), sum(obj.partition_struct.test(obj.current_fold)));
        end
    end
    
end

