% NoPartition - Do not partition the dataset
%   The NoPartition strategy creates a single fold containing all
%   points both in the training and in the test partitions. This
%   can be used to compute the training error, or to validate a model
%   on the training samples. It has no input parameters for
%   initialization.
%
%   See also: PartitionStrategy

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef NoPartition < PartitionStrategy
    
    properties
        y_length;   % Size of the dataset
    end
    
    methods
        function obj = NoPartition()
            % Initialize the NoPartition object
            obj.num_folds = 1;
        end
        
        function obj = partition(obj, Y)
            obj.y_length = length(Y);
            obj = obj.setCurrentFold(1);
        end
        
        function trainIndexes = getTrainingIndexes(obj)
            trainIndexes = true(obj.y_length, 1);
            
        end
        
        function testIndexes = getTestIndexes(obj)
            testIndexes = true(obj.y_length, 1);
        end
        
        function s = getFoldInformation(obj)
            s = sprintf('Training and testing on full dataset (%i samples)...\n', obj.y_length);
        end
    end
    
end

