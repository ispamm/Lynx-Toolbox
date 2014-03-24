classdef HoldoutPartition < PartitionStrategy
    
    %HOLDOUTPARTITION Represents an holdout partition, i.e., a single split
    %of the dataset with randomly generated indexes.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    properties
        holdout_fraction;   % Percentage of test samples
        partition_struct;   % cvpartition object to compute and hold the indexes
    end
    
    methods
        function obj = HoldoutPartition(holdout_fraction)
            assert(holdout_fraction > 0 && holdout_fraction < 1, 'LearnToolbox:ValError:HoldoutFractionInvalid', 'The specificied holdout fraction is invalid');
            obj.holdout_fraction = holdout_fraction;
            obj.num_folds = 1;
        end
        
        function obj = partition(obj, Y)
            warning('off', 'stats:cvpartition:HOTrainingZero');
            warning('off', 'stats:cvpartition:HOTestZero');
            obj.partition_struct = cvpartition(Y, 'holdout', obj.holdout_fraction);
            warning('on', 'stats:cvpartition:HOTrainingZero');
            warning('on', 'stats:cvpartition:HOTestZero');
            obj = obj.setCurrentFold(1);
        end
            
        function trainIndexes = getTrainingIndexes(obj)
            trainIndexes = obj.partition_struct.training(1);
        end
        
        function testIndexes = getTestIndexes(obj)
            testIndexes = obj.partition_struct.test(1);
        end
    end
    
end

