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

classdef DataDistributedLearningAlgorithm < LearningAlgorithm
    
    properties
        topology;
    end
    
    methods(Abstract=true)
        % Train the model
        obj = train_locally(obj, Xtr, Ytr);
        obj = finalizeTraining(obj);
    end
    
    methods

       function obj = DataDistributedLearningAlgorithm(model, varargin)
           obj = obj@LearningAlgorithm(model, varargin{:});
       end
       
       function obj = train(obj, Xtr, Ytr)
           spmd(obj.topology.N)
                obj = obj.train_locally(getLocalPart(Xtr), getLocalPart(Ytr));
           end
           obj = obj.finalizeTraining();
       end
       
       function idx = getNeighbors(obj, i)
           idx = obj.topology.getNeighbors(i);
       end
             
    end
    
end

