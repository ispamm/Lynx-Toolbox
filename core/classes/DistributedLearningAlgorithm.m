% DistributedLearningAlgorithm -

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
       end

       function obj = train(obj, dataset)
           
           obj = obj.executeBeforeTraining(size(dataset.X.data, 2));
           
           if(dataset.task == Tasks.MC)
                dataset.Y  = IntegerLabelsVector(dummyvar(dataset.Y.data));
           end
           
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

