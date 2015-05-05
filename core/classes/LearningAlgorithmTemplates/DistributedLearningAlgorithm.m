% DistributedLearningAlgorithm - A distributed learning algorithm
%   This is used to implement distributed learning algorithms. This is used
%   in two different modalities:
%
%   1) In parallel mode, each node is trained inside an SPMD block.
%   2) In non-parallel mode, no action is done.
%
%   Also, it is possible to distribute data throughout the nodes. All these
%   modalities can be activated/deactivated using the InitializeTopology
%   feature.
%

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef DistributedLearningAlgorithm < LearningAlgorithm & NetworkNode
    
    properties
        obj_locals;             % A cell array containing the local models
        distribute_data;        % Whether to distribute data samples
        distribute_features;    % Whether to distribute features
        partition_features;     % K-fold partition for the features
        parallelized;           % Enable the SPMD block
    end
    
    methods(Abstract=true)
        % Train the model
        obj = train_locally(obj, dataset);
    end
    
    methods
        
        function obj = DistributedLearningAlgorithm(model, varargin)
            obj = obj@LearningAlgorithm(model, varargin{:});
            obj.topology = [];
        end
        
        function obj = train(obj, dataset)
            
            if(isempty(obj.topology))
                error('Lynx:Runtime:MissingFeature', 'To use a distributed learning algorithm, please initialize the topology with the feature InitializeTopology');
            end

            if(obj.parallelized)
                % We are running inside an SPMD block (i.e., we use
                % codistributed arrays).
                
                if(obj.distribute_data)
                    fprintf('\t\tDistributing data (%i examples each approximately)...\n', floor(size(dataset.X.data, 1)/obj.topology.N));
                    spmd(obj.topology.N)
                        dataset.X.data = codistributed(dataset.X.data, codistributor1d(1));
                        dataset.Y.data = codistributed(dataset.Y.data, codistributor1d(1));
                        dataset.X.data = getLocalPart(dataset.X.data);
                        dataset.Y.data = getLocalPart(dataset.Y.data);
                    end
                elseif(obj.distribute_features)
                    fprintf('\t\tDistributing features (% features each approximately)...\n', floor(size(dataset.X.data, 2)/obj.topology.N));
                    spmd(obj.topology.N)
                        dataset.X.data = codistributed(dataset.X.data, codistributor1d(2));
                    end
                end
                
            elseif(obj.distribute_data)
                % For distributing data in non-parallel mode, we use a
                % simple K-fold partition on the number of samples.
                fprintf('\t\tEach node will have approximately %i patterns.\n', floor(size(dataset.X.data, 1)/obj.topology.N));
                dataset = dataset.generateSinglePartition(KFoldPartition(obj.topology.N));
            elseif(obj.distribute_features)
                % Similar to the previous situation, but we use a K-fold
                % partition on the number of features.
                fprintf('\t\tEach node will have approximately %i features.\n', floor(size(dataset.X.data, 2)/obj.topology.N));
                obj.partition_features = cvpartition(size(dataset.X.data, 2), 'kfold', obj.topology.N);
            end
            
            % Run before actual training (e.g. for initializing some parts
            % of the models)
            if(obj.parallelized)
                obj = obj.executeBeforeTraining(dataset{1});
            else
                obj = obj.executeBeforeTraining(dataset);
            end
            
            if(obj.parallelized)
                % Train in an SPMD block
                spmd(obj.topology.N)
                    try
                        o = obj.train_locally(dataset);
                    catch err
                        err.message;
                    end
                end
                % Recover the local models
                obj.obj_locals = o;
            else
                % Let the algorithm train the models, and recover the first
                % one
                obj.obj_locals{1} = obj.train_locally(dataset);
            end
            
            obj = obj.executeAfterTraining();
        end
        
        function obj = executeBeforeTraining(obj, d)
        end
        
        function obj = executeAfterTraining(obj)
            % Average stats throughout the models, and select the model of
            % the first node for comparing the errors.
            stats = cell(length(obj.obj_locals), 1);
            for i = 1:length(obj.obj_locals)
                o = obj.obj_locals{i};
                stats{i} = o.statistics;
            end
            obj = obj.obj_locals{1};
            obj.statistics = sum_structs(stats);
        end
        
        function d_local = getLocalPart(obj, d, ii)
            % Get the local part of the dataset
            if(obj.distribute_data)
                [~, d_local] = d.getFold(ii);
            elseif(obj.distribute_features)
                d_local = d;
                d_local.X.data = d_local.X.data(:, obj.partition_features.test(ii));
            else
                d_local = d;
            end
        end
        
    end
    
end

