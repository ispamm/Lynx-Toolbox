classdef ExactPartition < PartitionStrategy
    
    %EXACTPARTITION
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    properties
        training_samples;
        test_samples;
        N;
        partition_struct_full;   % cvpartition object to compute and hold the indexes
        partition_struct_training;
    end
    
    methods
        function obj = ExactPartition(training_samples, test_samples)
            assert(training_samples > 1 && test_samples > 1, 'LearnToolbox:ValError:NumberOfSamplesInvalid', 'The number of samples in an exact partition must be a positive integer');
            obj.training_samples = training_samples;
            obj.test_samples = test_samples;
            obj.num_folds = 1;
        end
        
        function obj = partition(obj, Y)
            warning('off', 'stats:cvpartition:HOTrainingZero');
            warning('off', 'stats:cvpartition:HOTestZero');
            if(obj.training_samples+obj.test_samples == length(Y))
                obj.partition_struct_full = cvpartition(Y, 'Resubstitution');
            else
                obj.partition_struct_full = cvpartition(Y, 'holdout', obj.training_samples + obj.test_samples);
            end
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

