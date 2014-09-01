% ExactPartition - Partition the data with a predefined number of samples
%
%   An ExactPartition is used for creating a split of a dataset with a
%   predefined number of samples for training and test.
%
%   Example:
%
%   p = ExactPartition(10, 15) creates a random split with 10 samples
%   for training and 15 samples for testing.
%
%   See also: PartitionStrategy

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef ExactPartition < PartitionStrategy
    
    properties
        training_samples;           % Indexes of the training samples
        test_samples;               % Indexes of the test samples
        N;                          % Size of the original dataset
        partition_struct_full;      % cvpartition object to compute the initial split
        partition_struct_training;  % cvpartition object to compute the training split from the initial split
    end
    
    methods
        function obj = ExactPartition(training_samples, test_samples)
            % Create an ExactPartition object. The two parameters are the
            % number of training and test samples to use in the split.
            assert(isnatural(training_samples, true) && isnatural(test_samples, true), 'Lynx:Validation:InvalidInput', 'The number of samples in an exact partition must be a positive integer');
            obj.training_samples = training_samples;
            obj.test_samples = test_samples;
            obj.num_folds = 1;
        end
        
        function obj = partition(obj, Y)
            warning('off', 'stats:cvpartition:HOTrainingZero');
            warning('off', 'stats:cvpartition:HOTestZero');
            
            % Check that Y has enough samples
            if(length(Y) < obj.training_samples + obj.test_samples)
                error('Lynx:Runtime:Partitioning', 'One of the datasets has not enough samples for the exact partitioning');
            end
            
            % The initial partition is used to obtain (training_samples +
            % test_samples) elements from the dataset.
            if(obj.training_samples+obj.test_samples == length(Y))
                obj.partition_struct_full = cvpartition(Y, 'Resubstitution');
            else
                obj.partition_struct_full = cvpartition(Y, 'holdout', obj.training_samples + obj.test_samples);
            end
            
            % From the initial partition, we generate the training
            % partition. This ensures a correct proportion of samples in
            % training and test.
            Ytmp = Y(obj.partition_struct_full.test);
            obj.partition_struct_training = cvpartition(Ytmp, 'holdout', obj.test_samples);
            
            warning('on', 'stats:cvpartition:HOTrainingZero');
            warning('on', 'stats:cvpartition:HOTestZero');
            
            obj = obj.setCurrentFold(1);
            obj.N = length(Y);
        end
        
        function trainIndexes = getTrainingIndexes(obj)
            tmp = find(obj.partition_struct_full.test == 1);
            trainIndexes = obj.partition_struct_full.test;
            trainIndexes(tmp(obj.partition_struct_training.test)) = 0;
        end
        
        function testIndexes = getTestIndexes(obj)
            tmp = find(obj.partition_struct_full.test == 1);
            testIndexes = obj.partition_struct_full.test;
            testIndexes(tmp(obj.partition_struct_training.training)) = 0;
        end
        
        function s = getFoldInformation(obj)
            s = sprintf('Training on %i samples and testing on %i samples\n', sum(obj.getTrainingIndexes()), sum(obj.getTestIndexes()));
        end
    end
    
end

