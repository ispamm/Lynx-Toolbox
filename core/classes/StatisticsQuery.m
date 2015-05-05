classdef StatisticsQuery
    
    properties
        stats;              % Current statistics
        params;             % Current parameters
        a_names;            % Names of the algorithms
        d_names;            % Names of the datasets
        sim;                % Simulation object (handle)
        value_container;    % Value container for storing results
        output_formatter;   % Output formatter
    end
    
    methods
        
        function obj = StatisticsQuery(s)
            % Initialize the object
            obj.sim = s;
            obj.stats = cellfun(@(x) x{1}.statistics, s.trainedAlgo, 'UniformOutput', false);
            obj.params = cellfun(@(x) x{1}.getParameters(), s.trainedAlgo, 'UniformOutput', false);
            obj.a_names = s.algorithms.getNames();
            obj.d_names = s.datasets.getNames();
            obj.value_container = NumericalContainer();
            obj.output_formatter = FormatAsTable();
        end
        
        function obj = filterByAlgorithmClass(obj, algo)
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
                        obj.stats{ii, jj, 1} = sum_structs(obj.stats(ii, jj, :));
                        obj.params{ii, jj, 1} = sum_structs(obj.params(ii, jj, :));
                    end
                end
                obj.stats(:, :, 2:end) = [];
                obj.params(:, :, 2:end) = [];
            end
            obj.stats = squeeze(obj.stats);
            obj.params = squeeze(obj.params);
        end
        
        function obj = logicalFilter(obj, algo_idx, d_idx)
            % Filter only datasets and algorithms with given indices
            if(isempty(algo_idx))
                algo_idx = 1:length(obj.a_names);
            end
            if(isempty(d_idx))
                algo_idx = 1:length(obj.d_names);
            end
            
            obj.stats = obj.stats(d_idx, algo_idx, :);
            obj.params = obj.params(d_idx, algo_idx, :);
            
            obj.a_names = obj.a_names(algo_idx);
            obj.d_names = obj.d_names(d_idx);
        end
        
        function obj = setOutputStyle(obj, v_cnt, o_fmt)
            if(nargin < 3)
                o_fmt = v_cnt.getDefaultOutputFormatter();
            end
            obj.value_container = v_cnt;
            obj.output_formatter = o_fmt;
        end
            
        function getQueryResult(obj, param_names)
            
            for r = 1:size(obj.stats, 3)
                
                for j = 1:size(obj.a_names)
                    
                    t = cell(length(obj.d_names), length(param_names));

                    % Get the parameters
                    for k = 1:length(param_names)
                        for i = 1:length(obj.d_names)
                            if(isfield(obj.stats{i, j, r}, param_names{k}))
                                t{i, k} = obj.value_container.store(obj.stats{i, j, r}.(param_names{k}));
                            elseif(isfield(obj.params{i, j, r}, param_names{k}))
                                t{i, k} = obj.value_container.store(obj.params{i, j, r}.(param_names{k}));
                            else
                                error('Lynx:Runtime:ParameterNotExisting', 'The parameter %s is not present', param_names{k});
                            end
                        end
                    end
                    
                    if(size(obj.stats, 3) > 1)
                        fprintf('Results for algorithm %s (RUN %i/%i):\n', obj.a_names{j}, r, size(obj.stats, 3));
                    else
                        fprintf('Results for algorithm %s:\n', obj.a_names{j});
                    end
                    obj.output_formatter.displayOnConsole(t, obj.d_names, param_names);
                    
                end
            end
            
        end
   

    end
    
end

