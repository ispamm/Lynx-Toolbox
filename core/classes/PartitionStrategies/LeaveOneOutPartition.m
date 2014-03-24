classdef LeaveOneOutPartition < PartitionStrategy
    
    %LEAVEONEOUTPARTITION Performs a leave-one-out partitioning. For a
    %generic dataset of N samples, this results in N different training
    %procedures, each time leaving out a particular sample.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    properties
        y_length;   % Length of the dataset
    end
    
    methods
        function obj = LeaveOneOutPartition()
        end
        
        function obj = partition(obj, Y)
            obj.y_length = length(Y);
            obj.num_folds = obj.y_length;
            obj = obj.setCurrentFold(1);
        end
            
        function trainIndexes = getTrainingIndexes(obj)
            trainIndexes = true(obj.y_length,1);
            trainIndexes(obj.current_fold) = false;
        end
        
        function testIndexes = getTestIndexes(obj)
            testIndexes = false(obj.y_length,1);
            testIndexes(obj.current_fold) = true;
        end
        
        function s = getFoldInformation(obj)
           s = sprintf('Leaving out sample %i of %i...\n', obj.current_fold, obj.num_folds); 
        end
    end
    
end

