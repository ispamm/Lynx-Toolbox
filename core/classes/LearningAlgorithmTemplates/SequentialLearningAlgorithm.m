% SequentialLearningAlgorithm - Sequential learning algorithm
%   A sequential learning algorithm trains sequentially, by accepting
%   multiple batches extracted from a dataset. This class has three
%   characteristics:
%       - Collect the parameters needed for the subdivision in batches
%       - Take care of subdividing the dataset and calling the training
%       updates
%       - Compute the evolution of the testing error at testing time
%   For an example of implementation, see OnlineSequentialELM.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef SequentialLearningAlgorithm < LearningAlgorithm
    
    properties
        models_history; % Cell array of old models (for testing)
        error_history;  % Cell array of errors
    end
    
    methods
        
        function obj = SequentialLearningAlgorithm(model, varargin)
            obj = obj@LearningAlgorithm(model, varargin{:});
        end
        
        function p = initParameters(obj, p)
            p.addParamValue('N0', 15, @(x) assert(isnatural(x, false), 'Initial block size of a sequential algorithm must be a non-zero natural number'));
            p.addParamValue('blockSize', 15, @(x) assert(isnatural(x, false), 'Block size of a sequential algorithm must be a non-zero natural number'));
        end
        
        function obj = train(obj, dataset)
            
            % Compute the number of batches
            size_afterinit = size(dataset.X.data, 1) - obj.parameters.N0;
            n_batches = floor(size_afterinit/obj.parameters.blockSize);
            obj.models_history = cell(n_batches + 1, 1);
            obj.error_history = cell(n_batches + 1, 1);
         
            % Get the initial batch
            dataset = dataset.generateSinglePartition(ExactPartition(obj.parameters.N0, size_afterinit));
            [dataset_init, dataset_rest] = dataset.getFold(1);
            obj = obj.train_init(dataset_init);
            obj.models_history{1} = obj;

            % Partition the remaining dataset
            if(n_batches > 1)
                dataset_rest = dataset_rest.generateSinglePartition(KFoldPartition(n_batches));
            else
                n_batches = 1;
                dataset_rest = dataset_rest.generateSinglePartition(NoPartition());
            end
            
            for n = 1:n_batches
                [~, dataset_batch] = dataset_rest.getFold(n);
                obj = obj.train_step(dataset_batch);
                obj.models_history{n+1} = obj;
            end
            
        end
        
        function errors = compute_error_history(obj, dataset)
            % Utility function for computing the evolution of the testing
            % error (used in the info_sequential script).
            p = PerformanceEvaluator.getInstance();
            p = p.getPrimaryPerformanceMeasure(dataset.task);

            errors = zeros(length(obj.models_history), 1);
            dataset = dataset.generateSinglePartition(NoPartition());
            for ii = 1:length(obj.models_history)
                [labels, scores] = obj.models_history{ii}.test(dataset);
                errors(ii) = p.compute(dataset.Y.data, labels, scores);
            end
        end
    end
    
    methods(Abstract)
        
        % Initialize the algorithm
        obj = train_init(obj, dataset_init);
        
        % Training step
        obj = train_step(obj, dataset_batch);
        
    end
    
    methods(Static)
        function info = getDescription()
            info = '';
        end
        
        function pNames = getParametersNames()
            pNames = {'N0', 'blockSize'};
        end
        
        function pInfo = getParametersDescription()
            pInfo = {'Size of initial block', 'Size of batches'};
        end
        
        function pRange = getParametersRange()
            pRange = {'Positive integer, default is 15', 'Positive integer, default is 15'};
        end
    end
    
end

