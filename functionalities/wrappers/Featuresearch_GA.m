% FeatureSearch_GA - Searches the optimal subset of features by using a genetic algorithm
%   This has three possible parameters:
%
%   add_wrapper(id, @Featuresearch_GA, 'popSize', 100) change the
%   population size of the GA (default 50).
%
%   add_wrapper(id, @Featuresearch_GA, 'gen', 10) change the number of
%   generations (default 10).
%
%   add_wrapper(id, @Featuresearch_GA, 'partition_strategy', p) change the
%   partition strategy (default KFoldPartition(3)).
%
%   This requires the Global Optimization toolbox.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef Featuresearch_GA < Wrapper
    
    properties
        bestFeatures;
    end
    
    methods
        
        function obj = Featuresearch_GA(wrappedAlgo, varargin)
            obj = obj@Wrapper(wrappedAlgo, varargin{:});
        end
        
        function p = initParameters(~, p)
            p.addParamValue('popSize', 50);
            p.addParamValue('gen', 10);
            p.addParamValue('partition_strategy', KFoldPartition(3));
        end
        
        function obj = train(obj, Xtr, Ytr)
            nVars = size(Xtr, 2);
            
            assert(obj.parameters.popSize > nVars, 'Lynx:Validation:PopulationError', 'For Featuresearch_GA, population size should be at least as large as the number of variables');
            
            % Add the individual with all features to the initial population
            InitialPopulation = ones(1, nVars);
            
            % Add the individuals with a single feature to the initial
            % population
            for i = 1:nVars
               oneValuedString = zeros(1, nVars);
               oneValuedString(i) = 1;
               InitialPopulation = [InitialPopulation; oneValuedString];
            end
            
            options = gaoptimset('Generations', obj.parameters.gen, 'PopulationType', 'bitstring', 'PopulationSize', obj.parameters.popSize, ...
                'Display', 'off', 'InitialPopulation', InitialPopulation);

            obj.bestFeatures = ga(@(feat) obj.computePerformanceIndividual(feat, Xtr, Ytr),nVars,[],[],[],[],[],[],[],options);
            
            if(SimulationLogger.getInstance().flags.debug)
                fprintf('\t\t Number of chosen features: %d\n', sum(obj.bestFeatures));
            end

            if(sum(obj.bestFeatures) == 0)
                error('Lynx:Runtime:AllFeaturesDeleted', 'All features were deleted by Featuresearch_GA...');
            end
            
            obj.wrappedAlgo = obj.wrappedAlgo.setCurrentTask(obj.getCurrentTask());
            obj.wrappedAlgo = obj.wrappedAlgo.train(Xtr(:, logical(obj.bestFeatures)), Ytr);
            
        end
        
        function perf = computePerformanceIndividual(obj, features, Xtr, Ytr)
            p = PerformanceEvaluator.getInstance();
            perfs = p.computePerformance(obj.wrappedAlgo,obj.constructDataset(Xtr, Ytr, features));
            perf = perfs{1}.getFinalizedValue();
            % Hack for positive performance measures (e.g.
            % MatthewCorrelationCoefficient)
            if(~isa(perfs{1}, 'LossFunction'))
                perf = -perf;
            end
        end
        
        function data = constructDataset(obj, X, Y, feat)
            data = Dataset.generateAnonymousDataset(obj.getCurrentTask(), X(:,logical(feat)), Y);
            data = data.generateSinglePartition(obj.parameters.partition_strategy);
        end
            
        function b = hasCustomTesting(obj)
            b = true;
        end
        
        function [labels, scores] = test_custom(obj, Xts)
            [labels, scores] = obj.wrappedAlgo.test(Xts(:, logical(obj.bestFeatures)));
        end
        
        function b = checkForPrerequisites(obj)
            b = obj.checkForPrerequisites@Wrapper();
            if(~exist('ga', 'file') == 2)
                error('Lynx:Runtime:MissingLibrary', 'The Featuresearch_GA wrapper requires the Global Optimization toolbox');
            end
        end
    end
    
    methods(Static)
        function info = getDescription()
            info = 'Search the optimal feature subset using a Genetic Algorithm';
        end
        
        function pNames = getParametersNames()
            pNames = {'partition_strategy', 'popSize', 'gen'}; 
        end
        
        function pInfo = getParametersDescription()
            pInfo = {'Partitioning strategy for validation', 'Size of the population', 'Number of generations'};
        end
        
        function pRange = getParametersRange()
            pRange = {'An object of class PartitionStrategy, default is 3-fold cross-validation', 'Positive integer, default 50', 'Positive integer, default 30'};
        end
    end
    
end