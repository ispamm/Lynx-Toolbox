% DataDistributedLearningAlgorithm - Data-distributed learning algorithm
%   This is a class for implementing fully distributed learning algorithms,
%   where each agent receives only a part of the overall training set,
%   although they converge to a single classifier.
%
%   This class stores internally the current network configuration, and
%   provides an easy access to it. Moreover, it takes charge of
%   distributing the training data on the labs.
%
%   Any implementation should extends a train_local method, which will be
%   executed locally on every lab with a partial subset of the training
%   data.
%
%   Topology is set using the DistributeData additional feature.
%
% See also: LearningAlgorithm, NetworkConfiguration, DistributeData

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef DataDistributedLearningAlgorithm < LearningAlgorithm & NetworkNode
    
    properties
    end
    
    methods(Abstract=true)
        % Train the model
        obj = train_locally(obj, Xtr, Ytr);
    end
    
    methods

       function obj = DataDistributedLearningAlgorithm(model, varargin)
           obj = obj@LearningAlgorithm(model, varargin{:});
       end
       
       function obj = train(obj, Xtr, Ytr)
           fprintf('\t\tDistributing data (%i examples each approximately)...\n', floor(size(Xtr, 1)/obj.topology.N));
           obj = obj.executeBeforeTraining(size(Xtr, 2));
           spmd(obj.topology.N)
                Xtr = codistributed(Xtr, codistributor1d(1));
                Ytr = codistributed(Ytr, codistributor1d(1));
                obj_local = obj.train_locally(getLocalPart(Xtr), getLocalPart(Ytr));
           end
           obj = obj.executeAfterTraining(obj_local);
       end
       
       function obj = executeBeforeTraining(obj, ~)
       end
       
       function obj = executeAfterTraining(obj, obj_local)
           stats = cell(length(obj_local), 1);
           for i = 1:length(obj_local)
               o = obj_local{i};
               stats{i} = o.statistics;
           end
           obj = obj_local{1};
           obj.statistics = sum_structs(stats);
       end
             
    end
    
end

