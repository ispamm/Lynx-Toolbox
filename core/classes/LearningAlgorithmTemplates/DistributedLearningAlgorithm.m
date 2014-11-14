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
        obj_locals;
        distribute_data;
        parallelized;
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
           
           obj = obj.executeBeforeTraining(size(dataset.X.data, 2));
           
           if(obj.distribute_data && obj.parallelized)
               
               fprintf('\t\tDistributing data (%i examples each approximately)...\n', floor(size(dataset.X.data, 1)/obj.topology.N));
               spmd(obj.topology.N)
                   dataset.X.data = codistributed(dataset.X.data, codistributor1d(1));
                   dataset.Y.data = codistributed(dataset.Y.data, codistributor1d(1));
                   dataset.X.data = getLocalPart(dataset.X.data);
                   dataset.Y.data = getLocalPart(dataset.Y.data);
               end
               
           elseif(obj.distribute_data)
               fprintf('\t\tEach node will have approximately %i patterns.\n', floor(size(dataset.X.data, 1)/obj.topology.N));
               dataset = dataset.generateSinglePartition(KFoldPartition(obj.topology.N));
           end
           
           if(obj.parallelized)
               spmd(obj.topology.N)
                   try
                       o = obj.train_locally(dataset);
                   catch err
                       err.message;
                   end
               end
               obj.obj_locals = o;
           else
               obj.obj_locals{1} = obj.train_locally(dataset);
           end
           
           obj = obj.executeAfterTraining();
       end
       
       function obj = executeBeforeTraining(obj, ~)
       end
       
       function obj = executeAfterTraining(obj)
           stats = cell(length(obj.obj_locals), 1);
           for i = 1:length(obj.obj_locals)
               o = obj.obj_locals{i};
               stats{i} = o.statistics;
           end
           obj = obj.obj_locals{1};
           obj.statistics = sum_structs(stats);
       end
       
       function d_local = getLocalPart(obj, d, ii)
            [~, d_local] = d.getFold(ii);
        end
       
    end
    
end

