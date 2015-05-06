classdef StatisticsQuery
    % StatisticsQuery - Query available statistics
    % This object can be used to easily retrieve statistics and parameters
    % from the simulation. First, initialize it with the Simulation object:
    %
    %   sq = StatisticsQuery(sq);
    %
    % The object stores internally all statistics and parameters of the
    % training algorithms, together with their names and trained models.
    % All structures are organized as DxAxR cell arrays, where D is the
    % number of datasets, A is the number of algorithms, and R is the
    % number of runs.
    %
    % Next, you can apply a series of filtering operations to restrict the
    % number of algorithms and/or datasets. As an example, we can select
    % only the algorithms of class ''SupportVectorMachine'' as:
    %
    %   sq = sq.filterByAlgorithmClass(''SupportVectorMachine'');
    %
    % Available filters are:
    %   - filterByAlgorithmClass (filter only algorithms in one or more
    %   classes).
    %   - averageByRun (average over the third dimension).
    %   - filterByAlgorithmID/filterByDatasetID (select only algorithms and
    %   datasets with the given indices).
    %   - filterByBooleanCondition (select only the algorithms that respect
    %   a given boolean predicate).
    %
    % Finally, you can select one or more statistics and/or properties by 
    % querying the object:
    %
    %   sq = sq.query({'C', 'trainingTime'});
    %
    % Results are saved in the property ''query_result'' as an Rx1 cell
    % array. Each element is a DxAxP cell array, where P is the number of
    % requested elements (2 in the previous example). If R = 1, the first
    % cell array is not created. If R = 1 and P = 1, you can convert the
    % result to a 3D matrix with:
    %
    %   sq = sq.convertToMatrix();
    %
    % This ensures that singleton dimensions are not removed (differently
    % from calling cell2mat on ''query_result'').
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    properties
        stats;              % Current statistics
        params;             % Current parameters
        t_algo;             % Trained algorithms
        a_names;            % Names of the algorithms
        d_names;            % Names of the datasets
        sim;                % Simulation object (handle)
        query_result;       % Result of the query
    end
    
    methods
        
        function obj = StatisticsQuery(s)
            % Initialize the object
            obj.sim = s;
            obj.stats = cellfun(@(x) x{1}.statistics, s.trainedAlgo, 'UniformOutput', false);
            obj.params = cellfun(@(x) x{1}.getParameters(), s.trainedAlgo, 'UniformOutput', false);
            obj.a_names = s.algorithms.getNames();
            obj.d_names = s.datasets.getNames();
            obj.t_algo = s.trainedAlgo;
        end
        
        function obj = filterByAlgorithmClass(obj, algo)
            % Filter by algorithm's class. Input can be a string or a cell
            % array of strings.
            
            algos = false(length(obj.a_names), 1);
            for i = 1:length(obj.a_names)
                if(iscell(algo))
                    for j = 1:length(algo)
                        if(obj.t_algo{1, i, 1}{1}.isOfClass(algo{j}))
                            algos(i) = true;
                        end
                    end
                else
                    if(obj.t_algo{1, i, 1}{1}.isOfClass(algo))
                        algos(i) = true;
                    end
                end
                
            end

            % Filter the statistics and parameters
            obj = obj.filterByAlgorithmID(algos);
            
        end
        
        function obj = averageByRun(obj)
            % Average by run
            
            obj.t_algo = obj.t_algo(:, :, 1);
            if(size(obj.stats, 3) > 1)
                for ii = 1:size(obj.stats, 1)
                    for jj = 1:size(obj.stats, 2)
                        obj.stats{ii, jj, 1} = sum_structs(obj.stats(ii, jj, :));
                        obj.params{ii, jj, 1} = sum_structs(obj.params(ii, jj, :));
                        warning('on', 'catstruct:DuplicatesFound');
                    end
                end
                obj.stats(:, :, 2:end) = [];
                obj.params(:, :, 2:end) = [];
            end
            obj.stats = squeeze(obj.stats);
            obj.params = squeeze(obj.params);
        end
        
        function obj = filterByAlgorithmID(obj, algo_idx)
            % Filter by algorithms' indices
            
            obj.stats = obj.stats(:, algo_idx, :);
            obj.params = obj.params(:, algo_idx, :);
            obj.t_algo = obj.t_algo(:, algo_idx, :);
            obj.a_names = obj.a_names(algo_idx);

        end
        
        function obj = filterByDatasetID(obj, d_idx)
            % Filter by datasets' indices
            
            obj.stats = obj.stats(d_idx, :, :);
            obj.params = obj.params(d_idx, :, :);
            obj.t_algo = obj.t_algo(d_idx, :, :);
            obj.d_names = obj.d_names(d_idx);
            
        end
        
        function obj = filterByBooleanCondition(obj, c, p)
            % Filter only algorithms of class ''c'' that respects the
            % boolean predicate ''p''. If c is not provided, the predicate
            % is applied to every algorithm.
            
            if(nargin < 3)
                p = c;
            end
            
            algos_to_remove = false(length(obj.a_names), 1);
            for i = 1:length(obj.a_names)
                a = obj.t_algo{1, i, 1}{1};
                if(nargin < 3 || a.isOfClass(c))
                    if(p(a))
                        algos_to_remove(i) = true;
                    end
                end
            end
            
            obj = obj.filterByAlgorithmID(algos_to_remove);
            
        end
            
        function obj = query(obj, param_names)
            % Query the object. Input is a cell array of strings
            % representing the desired properties and or statistics.
            
            obj.query_result = cell(size(obj.stats, 3), 1);
            
            for r = 1:size(obj.stats, 3)
                
                res_tmp = cell(length(obj.d_names), length(obj.a_names), length(param_names));
                
                for i = 1:length(obj.d_names)
                    
                    for j = 1:length(obj.a_names)
                    
                        for k = 1:length(param_names)
                        
                            if(isfield(obj.stats{i, j, r}, param_names{k}))
                                res_tmp{i, j, k} = obj.stats{i, j, r}.(param_names{k});
                            elseif(isfield(obj.params{i, j, r}, param_names{k}))
                                res_tmp{i, j, k} = (obj.params{i, j, r}.(param_names{k}));
                            else
                                error('Lynx:Runtime:ParameterNotExisting', 'The parameter %s is not present', param_names{k});
                            end
                            
                        end
                    end
                    
                end
                    
                if(size(obj.stats, 3) > 1)
                    obj.query_result{r} = res_tmp;
                else
                    obj.query_result = res_tmp;
                end
                
            end
            
        end
        
        function obj = convertToMatrix(obj)
            % Convert the result to a 3D matrix while keeping the singleton
            % dimensions.
            if(size(obj.query_result, 3) > 1)
                error('StatisticsQuery: cannot convert query to matrix with more than one run or more than one parameter');
            end
            res = zeros(length(obj.d_names), length(obj.a_names), length(obj.query_result{1,1,1}));
            for i = 1:length(obj.d_names)
                for j = 1:length(obj.a_names)
                    res(i, j, :) = obj.query_result{i, j};
                end
            end
            obj.query_result = res;
        end
   

    end
    
end

