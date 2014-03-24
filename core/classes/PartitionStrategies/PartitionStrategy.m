classdef PartitionStrategy
    % PARTITIONSTRATEGY A PartitionStragegy represents a way of
    % subdividing a dataset. Each strategy can have a varying number of
    % folds, each one providing a split of the data.
    %
    % PartitionStragegy Methods:
    %
    %   getNumFolds - Returns the number of folds of the given stragegy.
    %   
    %   partition - Initializes the folds of the dataset.
    %  
    %   setCurrentFold - Set the currently active fold.
    %
    %   getTrainingIndexes - Return the training indexes for the current
    %   fold.
    %
    %   getTestIndexes - Return the testing indexes for the current fold.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    properties
        current_fold;   % Current fold number
        num_folds;      % Overall number of folds
    end
    
    methods (Abstract)
        obj = partition(obj, Y);
        trainIndexes = getTrainingIndexes(obj);
        trainIndexes = getTestIndexes(obj);
    end
    
    methods
        function n = getNumFolds(obj)
            n = obj.num_folds;
        end
        
        function obj = setCurrentFold(obj, ii)
            assert(isnatural(ii) && ii <= obj.num_folds, 'LearnToolbox:Validation:WrongInput', 'Attempt to access fold %i, while maximum is %i', ii, obj.num_folds);
            obj.current_fold = ii;
        end
    end
    
end

