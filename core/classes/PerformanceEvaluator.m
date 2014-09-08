% PerformanceEvaluator - Evaluate an algorithm on a dataset
%    The PerformanceEvaluator is a singleton object that stores all the
%    current primary and secondary performance measures. It has methods
%    for setting/retrieving them, and two main methods:
%
% computePerformance - Compute the performance of an algorithm on a
% given dataset
%
% printDetailOfPerformanceMeasures - Display on screen details on the
% current performance measures

classdef PerformanceEvaluator < SingletonClass
    
    properties(Access=protected,Constant)
        singleton_id = 'perf_evaluator_task_obj';
    end
    
    properties
        primaryPerformanceMeasures;     % Main performance measures
        secondaryPerformanceMeasures;   % Secondary performance measures
    end
    
    methods(Access=protected)
        function obj = PerformanceEvaluator()
            obj = obj@SingletonClass();
            
            % Collect all the default performances
            tasks = Tasks.getAllTasks();
            obj.primaryPerformanceMeasures = cell(length(tasks), 1);
            obj.secondaryPerformanceMeasures = cell(length(tasks), 1);
            for ii = 1:length(tasks)
                obj.primaryPerformanceMeasures{tasks{ii}.getTaskId()} = tasks{ii}.getPerformanceMeasure();
                obj.secondaryPerformanceMeasures{tasks{ii}.getTaskId()} = {};
            end
        end
    end
    
    methods
        
        function obj = setPrimaryPerformanceMeasure(obj, t, p)
            % Set the primary performance measure for task t
            assert(isa(p, 'PerformanceMeasure'), 'Lynx:Runtime:InvalidPerformance', 'The provided performance measure is invalid');
            assert(p.isComparable(), 'Lynx:Runtime:InvalidPerformance', 'A primary performance measure must be comparable');
            obj.primaryPerformanceMeasures{uint32(t)} = p;
        end
        
        function obj = addSecondaryPerformanceMeasure(obj, t, p)
            % Add a performance measure for task t
            assert(isa(p, 'PerformanceMeasure'), 'Lynx:Runtime:InvalidPerformance', 'The provided performance measure is invalid');
            obj.secondaryPerformanceMeasures{uint32(t)}{end + 1} = p;
        end
        
        function p = getPrimaryPerformanceMeasure(obj, t)
            % Retrieve the primary performance measure for task t
            p = obj.primaryPerformanceMeasures{uint32(t)};
        end
        
        function p = getSecondaryPerformanceMeasures(obj, t)
            % Return the secondary performance measures for task t
            p = obj.secondaryPerformanceMeasures{uint32(t)};
        end
        
        function [perf, trainingTime, algo] = computePerformance(obj, algo, dataset, saveFold)
            % Compute performance of an algorithm on a dataset
            %
            % Input parameters:
            %   - algo is a LearningAlgorithm
            %   - dataset is a Dataset
            %   - saveFold is a boolean. If this is set to true, some
            %   informations on the current experiment are stored in the
            %   SimulationLogger
            %
            % Output values:
            %   perf - A cell array, where the first element is the value
            %   of the primare performance measure, and the other elements
            %   are the values of the secondary performance measures
            %   trainingTime - A TimeContainer with the training times
            %   algo - The resulting trained algorithm
            
            if(nargin < 4)
                saveFold = false;
            end
            
            folds = dataset.folds();
            trainingTime = TimeContainer();
            
            log = SimulationLogger.getInstance();
            
            % Initialize the perf object for output
            secPerfs = obj.secondaryPerformanceMeasures{uint32(dataset.task)};
            perf = cell(length(secPerfs) + 1, 1);
            perf{1} = obj.primaryPerformanceMeasures{uint32(dataset.task)};
            for i = 1:length(secPerfs)
                perf{i + 1} = secPerfs{i};
            end
            
            % Check if the current task is allowed
            if(~ algo.isDatasetAllowed(dataset))
                algo = [];
                return;
            end
            
            t_params = cell(1, folds);
            s_params = cell(1, folds);
            
            for ii = 1:folds

                t = clock;
                
                % Partition the data
                [dtrain, dtest, du] = dataset.getFold(ii);
                
                if(saveFold)
                    log.setAdditionalParameter('d_unsupervised', du);
                    log.setAdditionalParameter('fold', ii);
                end
                
                if(saveFold && log.flags.debug)
                    fprintf('\t%s', dataset.getFoldInformation(ii));
                end

                % Train the algorithm
                algo = algo.train(dtrain);
                
                % Store the training time
                trainingTime = trainingTime.store(etime(clock, t));
                
                % Test the algorithm
                [labels, scores] = algo.test(dtest);
                
                % Compute primary performance
                perf{1} = perf{1}.computeAndStore(dtest.Y.data, labels, scores);
                
                % Compute secondary performances
                for i = 1:length(secPerfs)
                    perf{i + 1} = perf{i + 1}.computeAndStore(dtest.Y.data, labels, scores);
                end
                
                % Collect training parameters and statistics
                t_params{ii} = algo.getParameters();
                s_params{ii} = algo.getStatistics();
                
            end
            
            % The overall trainingParams and statistics are averaged over the folds
            algo.parameters = sum_structs(t_params);
            algo.statistics = sum_structs(s_params);
            
        end
        
        function printDetailOfPerformanceMeasures(obj)
            % Print details on the current performance measures
            ts = Tasks.getAllTasks();
            for ii = 1:length(ts)
                secPerfs = obj.secondaryPerformanceMeasures{uint32(ts{ii}.getTaskId())};
                if(isempty(ts{ii}.getPerformanceMeasure()))
                    fprintf('\t * %s: No performance selected\n', ts{ii}.getDescription());
                else
                    fprintf('\t * %s: %s', ts{ii}.getDescription(), ts{ii}.getPerformanceMeasure().getDescription());
                    if(isempty(secPerfs))
                        fprintf('\n');
                    else
                        fprintf(' (and ');
                        for jj = 1:length(secPerfs)
                            fprintf('%s', secPerfs{jj}.getDescription());
                            if jj < length(secPerfs)
                                fprintf (', ');
                            else
                                fprintf(')\n');
                            end
                        end
                    end
                end
            end
        end
        
    end
    
    methods (Static)
        function singleObj = getInstance()
            singleObj = SingletonClass.getInstanceFromClass(PerformanceEvaluator());
        end
    end
end

