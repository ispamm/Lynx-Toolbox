% Dataset - A class for holding and partitioning a dataset
%   A dataset object can be used for storing a dataset, and
%   partitioning it using a predefined PartitionStrategy. You can
%   initialize a dataset as:
%
%   d = Dataset(X, Y, task);
%
%   Set an id and name as:
%
%   d = d.setIdAndName(id, name);
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
%   See also: PartitionStrategy, DataType.
%
% Dataset methods:
%
%   OBJ = DATASET(X, Y, TASK) constructs an object of type Dataset.
%
%   OBJ = OBJ.SETIDANDNAME(id, name) set is and name
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
        X;              % Input object (DataType)
        Y;              % Output object (DataType)
        info;           % Description
    end
    
    properties(Hidden)
        partitions;         % Partitions of the data
        ss_partitions;      % Semi-supervised partitions
        currentPartition;   % Index of the current partition
        ss_strategy;        % Strategy used for semi-supervised partitioning
        shuffles;           % Random shuffles of the data
    end
    
    methods
        function obj = Dataset(X, Y, task, info)
            % Constructor of the Dataset object. 
            % X and Y are the input and output DataType objects

            obj.task = task;
            assert(isa(X, 'DataType'), 'Lynx:Validation:InvalidInput', 'X must be a valid DataType object');
            assert(isa(Y, 'DataType') || isempty(Y), 'Lynx:Validation:InvalidInput', 'Y must be a valid DataType object');
            obj.X = X;
            obj.Y = Y;

            obj.partitions = [];
            if(nargin < 4)
                obj.info = '';
            else
                obj.info = info;
            end
     
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
                obj.shuffles{ii} = randperm(length(obj.Y.data));
                currentY = obj.Y.data(obj.shuffles{ii});
                
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
        
        function obj = setIdAndName(obj, id, name)
            % Set id and name of the dataset
            % id must be an alphanumerical string for identification, name
            % an alphanumerical string given as name.
            obj.id = id;
            obj.name = name;
        end
        
        function newDatasets = process(obj, f)
            % Process the dataset
            % Optional parameter is a DatasetFactory. If not provided, it
            % will be processed with the default DatasetFactory objects of
            % input and output.
            
            if(nargin == 2)
                newDatasets = f.process(obj);
            else
            
                firstProcessed = obj.Y.getDefaultFactory().process(obj);
                secondProcessed = {};
                for i = 1:length(firstProcessed)
                    fact = obj.X.getDefaultFactory();
                    secondProcessed = [secondProcessed, fact.process(firstProcessed{i})];
                end
                newDatasets = secondProcessed;
                
            end
        end
        
        function [Xtrn, Ytrn, Xtst, Ytst, Xu] = getFold(obj, ii)
            % Partition the data according to the current partition index
            % and fold ii
            
            assert(~isempty(obj.partitions), 'Lynx:Logical:PartitionsNotInitialized', 'Partitions of dataset %s have not been initialized', obj.name);
            
            shuff = obj.shuffles{obj.currentPartition};
            X = obj.X.shuffle(shuff);
            Y = obj.Y.shuffle(shuff);
            
            if(~isempty(obj.ss_strategy))
                ss_p = obj.ss_partitions{obj.currentPartition};
                [X, Xu] = X.partition(ss_p.getTestIndexes(), ss_p.getTrainingIndexes());
                [Y, ~] = Y.partition(ss_p.getTestIndexes(), ss_p.getTrainingIndexes());
                Xu = Xu.data;
            else
                Xu = [];
            end
            
            p = obj.partitions{obj.currentPartition};
            p = p.setCurrentFold(ii);
            
            [Xtrn, Xtst] = X.partition(p.getTrainingIndexes(), p.getTestIndexes());
            [Ytrn, Ytst] = Y.partition(p.getTrainingIndexes(), p.getTestIndexes());
            
            Xtrn = Xtrn.data;
            Ytrn = Ytrn.data;
            Xtst = Xtst.data;
            Ytst = Ytst.data;
            
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
        
        function s = getXDescription(obj)
            s = obj.X.getDescription();
        end
        
        function s = getYDescription(obj)
            if(~isempty(obj.Y))
                s = obj.Y.getDescription();
            else
                s = '';
            end
        end
            
    end
    
end

