classdef StatisticsCollector
    
    properties
        stats;   % Current statistics
        params;  % Current parameters
        a_names; % Names of the algorithms
        d_names; % Names of the datasets
        sim;     % Simulation object (handle)
    end
    
    methods
        
        function obj = StatisticsCollector(s)
            % Initialize the object
            obj.sim = s;
            obj.stats = cellfun(@(x) x{1}.statistics, s.trainedAlgo, 'UniformOutput', false);
            obj.params = cellfun(@(x) x{1}.getParameters(), s.trainedAlgo, 'UniformOutput', false);
            obj.a_names = s.algorithms.getNames();
            obj.d_names = s.datasets.getNames();
        end
        
        function obj = filterByAlgorithm(obj, algo)
            % Filter by algorithm's class
            
            % Get the index of the algorithms
            algos = find_algorithms(algo, obj.sim.algorithms);
            
            % Filter the statistics and parameters
            obj.stats = obj.stats(:, algos, :);
            obj.params = obj.params(:, algos, :);
            obj.a_names = obj.a_names(algos);
            
        end
        
        function obj = averageByRun(obj)
            % Average by run
            if(size(obj.stats, 3) > 1)
                for ii = 1:size(obj.stats, 1)
                    for jj = 1:size(obj.stats, 2)
                        obj.stats{ii, jj, 1} = sum_structs(obj.stats{ii, jj, :});
                        obj.params{ii, jj, 1} = sum_structs(obj.params{ii, jj, :});
                    end
                end
                obj.stats(:, :, 2:end) = [];
                obj.params(:, :, 2:end) = [];
            end
            obj.stats = squeeze(obj.stats);
            obj.params = squeeze(obj.params);
        end
        
        function formatAsTable(obj, algos_id, datasets_id, param_names)
            % Format the parameters as a table
            
            % First, we ensure that the results are averaged by run
            obj = obj.averageByRun();
            
            for i = 1:length(algos_id)
                % Initialize the result
                params_avg = zeros(length(datasets_id), length(param_names));

                % Get the parameters
                for k = 1:length(param_names)
                    if(isfield(obj.stats{datasets_id(1), algos_id(i)}, param_names{k}))
                        params_avg(:, k) = cellfun(@(x) x.(param_names{k}), obj.stats(datasets_id, algos_id(i)));
                    elseif(isfield(obj.params{datasets_id(1), algos_id(i)}, param_names{k}))
                        params_avg(:, k) = cellfun(@(x) x.(param_names{k}), obj.params(datasets_id, algos_id(i)));
                    else
                        error('Lynx:Runtime:ParameterNotExisting', 'The parameter %s is not present', param_names{k});
                    end
                end
                
                fprintf('Results for algorithm %s:\n', obj.a_names{algos_id(i)});
                disptable(params_avg, param_names, obj.d_names(datasets_id));
            end
            
        end
   

    end
    
end

