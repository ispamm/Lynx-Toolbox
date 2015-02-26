% DistributedEnsemble - Perform a distributed ensemble over the network
%   This can be used as a simple baseline against which to compare
%   distributed learning algorithms. In this wrapper, every node in the
%   network trains a local model with its local data. Then, in the testing
%   phase a naive ensembling operation is performed: for regression, the
%   wrapper computes the average of the local predictions, while for 
%   classification the mode of the predictions. This wrapper does not have
%   any parameter, and can be added as:
%
%       add_wrapper('ID', @DistributedEnsemble);
%
%   where 'ID' if the ID of the local learning algorithm to be used.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef DistributedEnsemble <  DistributedLearningAlgorithm & Wrapper
    
    properties
        local_models;   % Cell array of local models
    end
    
    methods
        
        function obj = DistributedEnsemble(wrappedAlgo, varargin)
            obj = obj@Wrapper(wrappedAlgo, varargin{:});
            obj = obj@DistributedLearningAlgorithm([], varargin{:});
        end
        
        function p = initParameters(~, p)
        end

        function obj = train_locally(obj, d)
            % Trains one model for each node
            for jj = 1:obj.topology.N
                obj.local_models{jj} = obj.wrappedAlgo.train(obj.getLocalPart(d, jj));
            end
        end
        
        function [labels, scores] = test_custom(obj, d)
            % Ensemble over the local models
            
            % Compute local predictions
            labels = zeros(size(d.X.data, 1), obj.topology.N);
            for jj = 1:obj.topology.N
                labels(:, jj) = obj.local_models{jj}.test(obj.getLocalPart(d, jj));
            end
            
            % Compute ensemble (i.e., the average for regression and the
            % most common value for classification).
            if(d.task == Tasks.R)
                labels = mean(labels, 2);
            else
                labels = mode(labels, 2);
            end
            scores = labels;
            
        end
        
        function b = hasCustomTesting(obj)
            b = true;
        end

    end
    
    methods(Static)
        function info = getDescription()
            info = 'Distributed ensemble over the network';
        end
    end
    
end

