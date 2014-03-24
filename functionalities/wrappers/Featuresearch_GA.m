classdef Featuresearch_GA < Wrapper
    % FEATURESEARCH_GA Searches the optimal subset of features by using a
    % genetic algorithm.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    properties
        bestFeatures;
    end
    
    methods
        
        function obj = Featuresearch_GA(wrappedAlgo, varargin)
            obj = obj@Wrapper(wrappedAlgo, varargin);
        end
        
        function initParameters(~, p)
            p.addParamValue('popSize', 50);
            p.addParamValue('gen', 10);
            p.addParamValue('partition_strategy', KFoldPartition(3));
        end
        
        function obj = train(obj, Xtr, Ytr)
            nVars = size(Xtr, 2);
            
            assert(obj.trainingParams.popSize > nVars, 'LearnToolbox:Validation:PopulationError', 'For Featuresearch_GA, population size should be at least as big as the number of variables');
            
            % Add the individual with all features to the initial population
            InitialPopulation = ones(1, nVars);
            
            % Add the individuals with a single feature to the initial
            % population
            for i = 1:nVars
               oneValuedString = zeros(1, nVars);
               oneValuedString(i) = 1;
               InitialPopulation = [InitialPopulation; oneValuedString];
            end
            
            options = gaoptimset('Generations', obj.trainingParams.gen, 'PopulationType', 'bitstring', 'PopulationSize', obj.trainingParams.popSize, ...
                'Display', 'off', 'InitialPopulation', InitialPopulation);
            
            fit = @(feat) mean(eval_algo(obj.wrappedAlgo, obj.constructDataset(Xtr, Ytr, feat)));
            obj.bestFeatures = ga(fit,nVars,[],[],[],[],[],[],[],options);
            
            if(SimulationLogger.getInstance().flags.debug)
                fprintf('\t\t Number of chosen features: %d\n', sum(obj.bestFeatures));
            end

            if(sum(obj.bestFeatures) == 0)
                error('LearnToolbox:RunTime:AllFeaturesDeleted', 'All features were deleted by Featuresearch_GA...');
            end
            
            obj.wrappedAlgo = obj.wrappedAlgo.setTask(obj.trainingParams.task);
            obj.wrappedAlgo = obj.wrappedAlgo.train(Xtr(:, logical(obj.bestFeatures)), Ytr);
            
        end
        
        function data = constructDataset(obj, X, Y, feat)
            data = Dataset.generateAnonymousDataset(obj.getTask(), X(:,logical(feat)), Y);
            data = data.generateNPartitions(1, obj.trainingParams.partition_strategy);
        end
            
        function [labels, scores] = test(obj, Xts)
            [labels, scores] = obj.wrappedAlgo.test(Xts(:, logical(obj.bestFeatures)));
        end
    end
    
    methods(Static)
        function info = getInfo()
            info = 'Search the optimal feature subset using a Genetic Algorithm';
        end
        
        function pNames = getParametersNames()
            pNames = {'partition_strategy', 'popSize', 'gen'}; 
        end
        
        function pInfo = getParametersInfo()
            pInfo = {'Partitioning strategy for validation', 'Size of the population', 'Number of generations'};
        end
        
        function pRange = getParametersRange()
            pRange = {'An object of class PartitionStrategy, default is 3-fold cross-validation', 'Positive integer, default 50', 'Positive integer, default 30'};
        end
    end
    
end