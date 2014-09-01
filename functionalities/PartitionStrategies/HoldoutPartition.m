% HoldoutPartition - Holdout partitioning
%   HoldoutPartition creates an holdout split of the dataset, i.e. a
%   single fold where the proportion of data between training and test
%   is specified by the user.
%
%   Example:
%
%   p = HoldoutPartition(0.25) - Create an holdout partition with 75%
%   samples for training and 25% for testing.
%
%   See also: PartitionStrategy

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef HoldoutPartition < PartitionStrategy
    
    properties
        holdout_fraction;   % Percentage of test samples
        partition_struct;   % cvpartition object to compute and hold the indexes
    end
    
    methods
        function obj = HoldoutPartition(holdout_fraction)
            % Create the HoldoutPartition object. The parameter
            % holdout_fraction must be a real number between 0 and 1.
            assert(isinrange(holdout_fraction, false), 'Lynx:Validation:InvalidInput', 'The specificied holdout fraction for HoldoutPartition is invalid');
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
        
        function s = getFoldInformation(obj)
            s = sprintf('Training on random %i%% (%i samples) and testing on the remaining %i%% (%i samples)\n', (1-obj.holdout_fraction)*100, sum(obj.getTrainingIndexes()), ...
                obj.holdout_fraction*100, sum(obj.getTestIndexes()));
        end
    end
    
end

