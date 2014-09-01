% PartitionStrategy - Strategy for partitioning a dataset (abstract)
%   A PartitionStrategy creates a predefined number of binary splits
%   from a given dataset, which can be used both for testing and for
%   validation purposes. Each split is denoted as a "fold".
%
%   Example:
%
%   Supposing that p is an object of a class extending
%   PartitionStrategy, use it by first initializing the partitions from
%   a given output vector Y:
%
%   p = p.partition(Y);
%
%   Then, set the desided fold index ii as:
%
%   p = p.setCurrentFold(ii);
%
%   Training and testing indexes of the current fold can be obtained
%   as:
%
%   trIdx = p.getTrainingIndexes();
%   tstIdx = p.getTestIndexes();
%
%   Any class extending PartitionStrategy must implement these methods,
%   plus a getFoldInformation() method for printing information on the
%   current fold during a simulation.
%
% PartitionStrategy Properties:
%
%   current_fold - The current fold index
%   num_folds - Total number of folds provided by the strategy
%
% PartitionStragegy Methods:
%
%   getNumFolds - Returns the total number of folds of the strategy
%
%   setCurrentFold - Set the current fold index
%
%   partition - Compute the splits from a given dataset and store them
%               internally
%
%   getTrainingIndexes - Return the training indexes for the current
%   fold
%
%   getTestIndexes - Return the testing indexes for the current fold

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef PartitionStrategy
    
    properties
        current_fold;   % Current fold index (can go from 1 to num_folds)
        num_folds;      % Total number of folds
    end
    
    methods (Abstract)
        % Initialize partitions from a given output vector Y
        obj = partition(obj, Y);
        % Get training indexes for current partition
        trainIndexes = getTrainingIndexes(obj);
        % Get test indexes for current partition
        testIndexes = getTestIndexes(obj);
        % Return a string describing the current fold
        s = getFoldInformation(obj);
    end
    
    methods
        function n = getNumFolds(obj)
            % Return the total number of folds
            n = obj.num_folds;
        end
        
        function obj = setCurrentFold(obj, ii)
            % Set the current fold index. ii must be an integer ranging
            % from 1 to obj.num_folds.
            assert(isnatural(ii) && ii <= obj.num_folds, 'Lynx:Validation:InvalidInput', 'Attempt to access fold %i, while maximum is %i', ii, obj.num_folds);
            obj.current_fold = ii;
        end
    end
    
end

