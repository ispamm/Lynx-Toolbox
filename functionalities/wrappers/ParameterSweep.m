% ParameterSweep - Grid search procedure
%   This allows to search the parameters of a model by running a grid
%   search procedure. A typical call is as follows:
%
%   add_wrapper('MLP', @ParameterSweep, {'hiddenNodes'}, {1:10});
%
%   This searches the optimal number of hidden nodes of a
%   MultilayerPerceptron in the range 1, ..., 10, using a 3-fold cross
%   validation as performance measure.
%
%   To change the partition strategy to the object p:
%
%   add_wrapper('MLP', @ParameterSweep, {'hiddenNodes'}, {1:10}, 'partition_strategy', p);

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef ParameterSweep < Wrapper
    
    properties
        bestParams;
    end
    
    methods
        
        function obj = ParameterSweep(wrappedAlgo, varargin)
            obj = obj@Wrapper(wrappedAlgo, varargin{:});
        end
        
        function p = initParameters(~, p)
            p.addRequired('parameterNames');
            p.addRequired('ranges');
            p.addParamValue('partition_strategy', KFoldPartition(3));
            p.addParamValue('finalTraining', true);
        end
        
        function obj = train(obj, Xtr, Ytr)
            dataset = obj.generateDataset(RealMatrix(Xtr), Ytr);
            dataset = dataset.generateSinglePartition(obj.parameters.partition_strategy);
            
            bestPerf = [];
            
            combinations = combvec(obj.parameters.ranges{:});
            
            if(size(combinations, 1) <= 2)
                obj.statistics.valErrorGrid = zeros(size(combinations, 2), 1);
            end
            
            for zz=1:size(combinations, 2)
                
                paramsToTest = combinations(:,zz);
                
                for i=1:length(obj.parameters.parameterNames)
                    obj.wrappedAlgo = obj.wrappedAlgo.setParameter(obj.parameters.parameterNames{i}, paramsToTest(i));
                end
                
                currentPerf = PerformanceEvaluator.getInstance().computePerformance(obj.wrappedAlgo, dataset);
                
                if(isempty(bestPerf))
                    bestPerf = currentPerf{1};
                    obj.bestParams = combinations(:, 1);
                end
                
                if(currentPerf{1}.isBetterThan(bestPerf))
                    bestPerf = currentPerf{1};
                    obj.bestParams = combinations(:, zz);
                end
                
                if(size(combinations, 1) <= 2)
                    obj.statistics.valErrorGrid(zz) = currentPerf{1}.getFinalizedValue();
                end
                
            end
            
            if(size(combinations, 1) == 2)
                obj.statistics.valErrorGrid = reshape(obj.statistics.valErrorGrid, length(obj.parameters.ranges{1}), length(obj.parameters.ranges{2}));
            end
            
            if(SimulationLogger.getInstance().flags.debug)
                bestParamsCell = num2cell(obj.bestParams);
                fprintf('\t\t Validated parameters: [ ');
                for i=1:length(bestParamsCell)
                    fprintf('%s = %f ', obj.parameters.parameterNames{i}, bestParamsCell{i});
                end
                fprintf('], with performance: %s\n', bestPerf.formatForOutput());
            end
            
            for i=1:length(obj.parameters.parameterNames)
                obj.wrappedAlgo = obj.wrappedAlgo.setParameter(obj.parameters.parameterNames{i}, obj.bestParams(i));
            end
            
            t = clock;
            
            if(obj.parameters.finalTraining)
                obj.wrappedAlgo = obj.wrappedAlgo.train(Xtr, Ytr);
            else
                [Xtr, Ytr, ~, ~, ~, ~] = dataset.getFold(1);
                obj.wrappedAlgo = obj.wrappedAlgo.train(Xtr, Ytr);
            end
            
            trainingTime = etime(clock, t);
            if(SimulationLogger.getInstance().flags.debug)
                fprintf('\t\t Final training time is: %.2f secs\n', trainingTime);
            end
            
            
            obj.statistics.bestPerf = bestPerf;
            obj.statistics.finalTrainingTime = trainingTime;
            
        end
        
    end
    
    methods(Static)
        function info = getDescription()
            info = 'Search the optimal parameters using a grid search procedure. Differently from other wrappers, all parameters are required.';
        end
        
        function pNames = getParametersNames()
            pNames = {'partition_strategy', 'parameterNames', 'ranges'};
        end
        
        function pInfo = getParametersDescription()
            pInfo = {'Partition strategy for validation', 'Name of the parameters to be searched', 'Cell array of values for each parameter'};
        end
        
        function pRange = getParametersRange()
            pRange = {'An object of class PartitionStrategy', 'Cell array of M strings', ...
                'Cell array of M ranges'};
        end
    end
    
end