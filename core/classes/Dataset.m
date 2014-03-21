classdef Dataset
    
    %DATASET A class for holding a dataset. It allows automatic
    %partitioning of the data.
    %
    % Dataset methods:
    %
    %   OBJ = DATASET(ID, NAME, TASK, X, Y) constructs an object of type
    %   Dataset.
    %
    %   OBJ = OBJ.GENERATENPARTITIONS(N, P) internally constructs N
    %   partitions of the dataset, which can be holdout or k-fold depending
    %   on P.
    %
    %   OBJ = OBJ.SETCURRENTPARTITION(I) set the active partition to the
    %   i-th one. This can only be called after the partitions have been
    %   generated, otherwise an error will be thrown.
    %
    %   [XTRN, YTRN, XTST, YTST] = OBJ.GETFOLD(I) returns the training and
    %   testing data subdivided on the base of the current partition.
    %
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    properties
        id;   % The alphanumerical ID of the dataset
        name; % The alphanumerical name of the dataset 
        task; % The task associated to this dataset
        X;    % Nxd input matrix
        Y;    % Nx1 output matrix
        isKernelMatrix; % Whether this stores a kernel matrix
    end
    
    properties(Hidden)
        partitions;
        ss_partitions;
        currentPartition;
        kfold;
        ss_fraction;
    end
    
    methods
        function obj = Dataset(id, name, task, X, Y, isKernelMatrix)
            if(nargin < 6)
                obj.isKernelMatrix = false;
            else
                obj.isKernelMatrix = isKernelMatrix;
            end
            assert(ischar(id), 'LearnToolbox:Validation:WrongInput', '%s is not a valid identifier for a dataset', id);
            obj.id = id;
            assert(ischar(name), 'LearnToolbox:Validation:WrongInput', '%s is not a valid name for a dataset', name);
            obj.name = name;
            obj.task = task;
            assert(isnumeric(X), 'LearnToolbox:Validation:WrongInput', 'X matrix of dataset %s is invalid', name);
            obj.X = X;
            if(task == Tasks.R || task == Tasks.BC || task == Tasks.MC)
                assert(isnumeric(Y) && length(Y) == size(X, 1), 'LearnToolbox:Validation:WrongInput', 'Y matrix of dataset %s is invalid', name);
            end
            obj.Y = Y;
            obj.partitions = [];
        end
        
        function obj = generateNPartitions(obj, N, partitionParameter, ss_fraction)
            if(nargin < 4)
                ss_fraction = 0;
            end
            
            obj.partitions = cell(N, 1);
            obj.currentPartition = 1;
            if(isnatural(partitionParameter, true))
                obj.kfold = true;
                p = 'kfold';
            else
               obj.kfold = false;
               p = 'holdout';
               %partitionParameter = 1 - partitionParameter;
            end
            
            warning('off', 'stats:cvpartition:KFoldMissingGrp');
            warning('off', 'stats:cvpartition:HOTrainingZero');
            warning('off', 'stats:cvpartition:HOTestZero');
            for ii=1:N
                if(ss_fraction > 0)
                    if(obj.task == Tasks.R)
                        obj.ss_partitions{ii} = cvpartition(length(obj.Y), 'holdout', ss_fraction);
                        obj.partitions{ii} = cvpartition(length(obj.Y(training(obj.ss_partitions{ii}))), p, partitionParameter);
                    else
                        obj.ss_partitions{ii} = cvpartition(obj.Y, 'holdout', ss_fraction);
                        obj.partitions{ii} = cvpartition(obj.Y(training(obj.ss_partitions{ii})), p, partitionParameter);
                    end
                else
                    if(obj.task == Tasks.R)
                        obj.partitions{ii} = cvpartition(length(obj.Y), p, partitionParameter);
                    else
                        obj.partitions{ii} = cvpartition(obj.Y, p, partitionParameter);
                    end
                end
            end
            warning('on', 'stats:cvpartition:KFoldMissingGrp');
            warning('on', 'stats:cvpartition:HOTrainingZero');
            warning('on', 'stats:cvpartition:HOTestZero');
            obj.ss_fraction = ss_fraction;
        end
        
        function f = folds(obj)
            f = obj.partitions{1}.NumTestSets;
        end
        
        function obj = setCurrentPartition(obj, ii)
            assert(~isempty(obj.partitions), 'LearnToolbox:Logic:PartitionsNotInitialized', 'Partitions of dataset %s have not been initialized', obj.name);
            assert(isnatural(ii) && ii <= length(obj.partitions), 'LearnToolbox:Validation:WrongInput', 'Partitions of dataset %s have not been initialized', obj.name);
            obj.currentPartition = ii;
        end
        
        function [Xtrn, Ytrn, Xtst, Ytst, Xu] = getFold(obj, ii)
            
            assert(~isempty(obj.partitions), 'LearnToolbox:Logic:PartitionsNotInitialized', 'Partitions of dataset %s have not been initialized', obj.name);
            if(obj.kfold)
                assert(isnatural(ii,true) && ii <= obj.partitions{obj.currentPartition}.NumTestSets, 'LearnToolbox:Validation:WrongInput', 'Cannot fetch fold %i for dataset %s', ii, obj.name);
            else
                assert(~obj.kfold && (ii == 1), 'LearnToolbox:Validation:WrongInput', 'In holdout mode, one can fetch a single fold');
            end
            
            X = obj.X;
            Y = obj.Y;
            
            if(obj.ss_fraction > 0)
                ss_p = obj.ss_partitions{obj.currentPartition};
                Xu = X(test(ss_p), :);
                X = X(training(ss_p), :);
                Y = Y(training(ss_p));
            else
                Xu = [];
            end
            
            p = obj.partitions{obj.currentPartition};
            
            if(obj.isKernelMatrix)
                Xtrn = X(p.training(ii), p.training(ii));
                Xtst = X(p.test(ii), p.training(ii));
            else
                Xtrn = X(p.training(ii), :);
                Xtst = X(p.test(ii), :);
            end
        
            Ytrn = Y(p.training(ii));
            Ytst = Y(p.test(ii));
            
        end
        
        function obj = shuffle(obj)
            shuff = randperm(length(obj.Y));
            obj.X = obj.X(shuff, :);
            obj.Y = obj.Y(shuff);
        end
    end
    
end

