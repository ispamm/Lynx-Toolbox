classdef ParameterSweep < Wrapper
    % PARAMETERSWEEP This allows to search the parameters of a model by
    % running a grid search procedure. A typical call is as follows:
    %
    %   add_wrapper('MLP', @ParameterSweep, KFoldPartition(3), {'hiddenNodes'}, {'lin'}, [1
    %   10], [1]);
    %
    %   This searches the optimal number of hidden nodes of a
    %   MultilayerPerceptron in the range 1, ..., 10, using a 3-fold cross
    %   validation as performance measure.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    properties
        bestParams;
    end
    
    methods
        
        function obj = ParameterSweep(wrappedAlgo, varargin)
            obj = obj@Wrapper(wrappedAlgo, varargin);
        end
        
        function initParameters(~, p)
            p.addRequired('partition_strategy');
            p.addRequired('parameterNames');
            p.addRequired('sweep_type');
            p.addRequired('bounds');
            p.addRequired('steps'); 
            p.addParamValue('finalTraining', true);
        end
        
        function obj = train(obj, Xtr, Ytr)
            params_tosearch = cell(1, length(obj.trainingParams.parameterNames));

            for i = 1:length(obj.trainingParams.parameterNames)
                interval = obj.trainingParams.bounds(i, :);
                values = interval(1):obj.trainingParams.steps(i):interval(2);
                if(strcmp(obj.trainingParams.sweep_type{i}, 'exp'))
                    values = 2.^(values);    
                end
            params_tosearch{i} = values;
            end

            dataset = Dataset.generateAnonymousDataset(obj.getTask(), Xtr, Ytr);
            dataset = dataset.generateNPartitions(1, obj.trainingParams.partition_strategy);
            
            [ obj.bestParams, bestError, obj.statistics.valErrorGrid ] = grid_search( obj.wrappedAlgo, dataset, obj.trainingParams.parameterNames, params_tosearch );
            
            if(SimulationLogger.getInstance().flags.debug)
                bestParamsCell = num2cell(obj.bestParams);
                fprintf('\t\t Validated parameters: [ ');
                for i=1:length(bestParamsCell)
                    fprintf('%s = %f ', obj.trainingParams.parameterNames{i}, bestParamsCell{i});
                end
                fprintf('], with error: %f\n', bestError);
            end
            
            for i=1:length(obj.trainingParams.parameterNames)
               obj.wrappedAlgo = obj.wrappedAlgo.setTrainingParam(obj.trainingParams.parameterNames{i}, obj.bestParams(i));
            end
            
            obj.wrappedAlgo = obj.wrappedAlgo.setTask(obj.getTask());
            t = clock;
            
            if(obj.trainingParams.finalTraining)
                obj.wrappedAlgo = obj.wrappedAlgo.train(Xtr, Ytr);
            else
                [Xtr, Ytr, ~, ~, ~, ~] = dataset.getFold(1);
                obj.wrappedAlgo = obj.wrappedAlgo.train(Xtr, Ytr);
            end
            
            trainingTime = etime(clock, t);
            if(SimulationLogger.getInstance().flags.debug)
                fprintf('\t\t Final training time is: %f\n', trainingTime);
            end
            obj.statistics.bestError = bestError;
            obj.statistics.finalTrainingTime = trainingTime;
            
        end
    
        function [labels, scores] = test(obj, Xts)
            [labels, scores] = obj.wrappedAlgo.test(Xts);
        end
    end
    
    methods(Static)
        function info = getInfo()
            info = 'Search the optimal parameters using a grid search procedure. Differently from other wrappers, all parameters are required.';
        end
        
        function pNames = getParametersNames()
            pNames = {'partition_strategy', 'parameterNames', 'sweep_type', 'bounds', 'steps'}; 
        end
        
        function pInfo = getParametersInfo()
            pInfo = {'Partition strategy for validation', 'Name of the parameters to be searched', 'Type of interval', ...
                'Lower and upper bounds', 'Steps for constructing the intervals'};
        end
        
        function pRange = getParametersRange()
            pRange = {'An object of class PartitionStrategy', 'Cell array of M strings', ...
                'Cell array of M strings in {lin, exp}', '2xM vector of numbers', 'Mx1 vector of real numbers'};
        end 
    end
    
end