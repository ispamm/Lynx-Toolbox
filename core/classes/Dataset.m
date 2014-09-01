% Dataset - A class for holding and partitioning a dataset
%   A dataset object can be used for storing a dataset, and
%   partitioning it using a predefined PartitionStrategy. You can
%   initialize a dataset as:
%
%   d = Dataset(id, name, task, X, Y);
%
%   Or in an anonymous way as:
%
%   d = Dataset.generateAnonymousDataset(task, X, Y);
%
%   Then, you can generate N different partitions as:
%
%   d = d.generateNPartitions(N, partition_strategy);
%
%   In a semi-supervised mode, another partition strategy is required:
%
%   d = d.generateNPartitions(N, partition_strategy, ss_partition_strategy);
%
%   Set the current partition number as:
%
%   d = d.setCurrentPartition(ii);
%
%   Finally, get the partitioned data of fold i as:
%
%   [Xtr, Ytr, Xtst, Ytst, Xu] = d.getFold(i);
%
%   Dataset can also be used to store a kernel matrix K in place of the
%   input matrix X. In this case, initialize with an additional boolean
%   as:
%
%   d = Dataset(id, name, task, K, Y, true);
%
%   See also: PartitionStrategy.
%
% Dataset methods:
%
%   OBJ = DATASET(ID, NAME, TASK, X, Y) constructs an object of type
%   Dataset.
%
%   OBJ = OBJ.GENERATENPARTITIONS(N, P) internally constructs N
%   partitions of the dataset using the PartitionStrategy P
%
%   OBJ = OBJ.GENERATESINGLEPARTITION(P) constructs a single partition
%
%   OBJ = OBJ.SETCURRENTPARTITION(I) set the active partition to the
%   i-th one. This can only be called after the partitions have been
%   generated, otherwise an error will be thrown.
%
%   [XTRN, YTRN, XTST, YTST] = OBJ.GETFOLD(I) returns the training and
%   testing data subdivided on the base of the current partition.
%
%   [XTRN, YTRN, XTST, YTST, XU] = OBJ.GETFOLD(I) is the same as
%   before, but also returns the unlabeled inputs for semi-supervised
%   training
%
%   D = DATASET.CREATEANONYMOUSDATASET(TASK, X, Y) creates a Dataset
%   object, without information on the name and the id associated to it
%   (useful inside wrappers)

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef Dataset
    
    properties
        id;             % The alphanumerical ID of the dataset
        name;           % The alphanumerical name of the dataset 
        task;           % The task associated to this dataset
        X;              % Nxd input matrix (or NxN kernel matrix)
        Y;              % Nx1 output matrix
        isKernelMatrix; % Whether this stores a kernel matrix
    end
    
    properties(Hidden)
        partitions;         % Partitions of the data
        ss_partitions;      % Semi-supervised partitions
        currentPartition;   % Index of the current partition
        ss_strategy;        % Strategy used for semi-supervised partitioning
        shuffles;           % Random shuffles of the data
    end
    
    methods
        function obj = Dataset(id, name, task, X, Y, isKernelMatrix)
            % Constructor of the Dataset object. id is an alphanumerical
            % string for identification, name is a an alphanumerical string
            % given as name, X and Y are the input and output matrices, and
            % isKernelMatrix is a boolean indicating whether X is a kernel
            % matrix or not. This last parameter is optional and defaults
            % to false.
            
            if(nargin < 6)
                obj.isKernelMatrix = false;
            else
                obj.isKernelMatrix = isKernelMatrix;
            end

            % Check that all inputs are valid
            assert(ischar(id), 'Lynx:Validation:InvalidInput', '%s is not a valid identifier for a dataset', id);
            obj.id = id;
            assert(ischar(name), 'Lynx:Validation:InvalidInput', '%s is not a valid name for a dataset', name);
            obj.name = name;
            obj.task = task;
            assert(isnumeric(X), 'Lynx:Validation:InvalidInput', 'X matrix of dataset %s is invalid', name);
            obj.X = X;
            if(task == Tasks.R || task == Tasks.BC || task == Tasks.MC)
                assert(isnumeric(Y) && length(Y) == size(X, 1), 'Lynx:Validation:InvalidInput', 'Y matrix of dataset %s is invalid', name);
            end
            obj.Y = Y;
            obj.partitions = [];
        end
        
        function obj = generateNPartitions(obj, N, partitionStrategy, ss_partitionStrategy)
            % Generate N partitions of the dataset using a given
            % partitioning strategy. In semi-supervised mode, two
            % strategies must be provided.
            
            if(nargin < 4)
                obj.ss_strategy = [];
            else
                obj.ss_strategy = ss_partitionStrategy;
            end
            
            obj.partitions = cell(N, 1);
            obj.shuffles = cell(N, 1);
            obj.currentPartition = 1;
            obj.ss_partitions = cell(N, 1);
            
            for ii=1:N
                % Shuffle the dataset
                obj.shuffles{ii} = randperm(length(obj.Y));
                currentY = obj.Y(obj.shuffles{ii});
                
                if(~isempty(obj.ss_strategy))
                    obj.ss_partitions{ii} = obj.ss_strategy.partition(currentY);
                    obj.partitions{ii} = partitionStrategy.partition(currentY(obj.ss_partitions{ii}.getTrainingIndexes));
                else
                    obj.partitions{ii} = partitionStrategy.partition(currentY);
                end
            end
            
        end
        
        function obj = generateSinglePartition(obj, partitionStrategy, ss_partitionStrategy)
            % Commodity method for generating a single partition
           if(nargin == 3)
               obj = obj.generateNPartitions(1, partitionStrategy, ss_partitionStrategy);
           else
               obj = obj.generateNPartitions(1, partitionStrategy);
           end
        end
        
        function f = folds(obj)
            % Get the number of folds
            f = obj.partitions{1}.getNumFolds();
        end
        
        function obj = setCurrentPartition(obj, ii)
            % Set the current partition index
            assert(~isempty(obj.partitions), 'Lynx:Logical:PartitionsNotInitialized', 'Partitions of dataset %s have not been initialized', obj.name);
            assert(isnatural(ii) && ii <= length(obj.partitions), 'Lynx:Validation:InvalidInput', 'Partitions of dataset %s have not been initialized', obj.name);
            obj.currentPartition = ii;
        end
        
        function [Xtrn, Ytrn, Xtst, Ytst, Xu, Yu] = getFold(obj, ii)
            % Partition the data according to the current partition index
            % and fold ii
            
            assert(~isempty(obj.partitions), 'Lynx:Logical:PartitionsNotInitialized', 'Partitions of dataset %s have not been initialized', obj.name);
            
            shuff = obj.shuffles{obj.currentPartition};
            
            if(obj.isKernelMatrix)
                X = obj.X(shuff, shuff);
            else
                X = obj.X(shuff, :);
            end
            
            Y = obj.Y(shuff);
            
            if(~isempty(obj.ss_strategy))
                ss_p = obj.ss_partitions{obj.currentPartition};
                Xu = X(ss_p.getTestIndexes(), :);
                Yu = Y(ss_p.getTestIndexes());
                X = X(ss_p.getTrainingIndexes(), :);
                Y = Y(ss_p.getTrainingIndexes());
            else
                Xu = [];
                Yu = [];
            end
            
            p = obj.partitions{obj.currentPartition};
            p = p.setCurrentFold(ii);
            
            if(obj.isKernelMatrix)
                Xtrn = X(p.getTrainingIndexes(), p.getTrainingIndexes());
                Xtst = X(p.getTestIndexes(), p.getTrainingIndexes());
            else
                Xtrn = X(p.getTrainingIndexes(), :);
                Xtst = X(p.getTestIndexes(), :);
            end
        
            Ytrn = Y(p.getTrainingIndexes());
            Ytst = Y(p.getTestIndexes());
            
        end
        
        function obj = shuffle(obj)
            % Randomly shuffle the data
            shuff = randperm(length(obj.Y));
            obj.X = obj.X(shuff, :);
            obj.Y = obj.Y(shuff);
        end
        
        function s = getFoldInformation(obj, ii)
            % Get information on the ii-th fold of the current partition
            obj.partitions{obj.currentPartition} = obj.partitions{obj.currentPartition}.setCurrentFold(ii);
            s = obj.partitions{obj.currentPartition}.getFoldInformation();
        end
        
        function s = getCurrentShuffle(obj)
            % Get the current shuffling indices
            s = obj.shuffles{obj.currentPartition()};
        end
            
    end
    
    methods(Static)
        function d = generateAnonymousDataset(task, X, Y, isKernelMatrix)
            % Commodity function for generating a dataset with no name and
            % no id
            if(nargin < 4)
                isKernelMatrix = false;
            end
            d = Dataset('', '', task, X, Y, isKernelMatrix);
        end
    end
    
end

