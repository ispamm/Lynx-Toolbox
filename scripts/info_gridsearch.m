
% INFO_GRIDSEARCH Print info on any grid search procedure executed during
% the simulation

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

PRINT_GRAPHS = true;

s = Simulation.getInstance();

sq = StatisticsQuery(s);
sq = sq.filterByAlgorithmClass('ParameterSweep').averageByRun();

% Print results
for a = 1:length(sq.a_names)
    
    parameters_sweeped = sq.t_algo{1,a,1}{1}.getParameter('parameterNames');
    parameters_range = sq.t_algo{1,a,1}{1}.getParameter('ranges');
    parameters_range = parameters_range{1};
    sq_params = sq.filterByAlgorithmID(a).query(parameters_sweeped{1});

    params = cell2mat(sq_params.query_result);
    t_time = sq.filterByAlgorithmID(a).query({'finalTrainingTime'}).convertToMatrix().query_result;
    
    cprintf('*text', 'Results of grid search for algorithm %s: \n', sq.a_names{a});
    tmp = squeeze(params);
    if(size(tmp, 1) ~= length(sq.d_names))
        tmp = tmp';
    end
    disptable([tmp t_time], [parameters_sweeped{1}, 'T. Time'], sq_params.d_names);
    
    % Plot validation error
    if(PRINT_GRAPHS)
        try
            sq_grid = sq.filterByAlgorithmID(a).query({'valErrorGrid'});
        catch
            sq_grid = [];
        end
        
        if(~isempty(sq_grid))
        
            % HORRIBLE HACK (for exponential plots)
            if(abs(parameters_range{1}(end-1)*2 - parameters_range{1}(end)) < 10^-10 || abs(parameters_range{1}(end-1)*10 - parameters_range{1}(end)) < 10^-10)
                exp_1 = true;
            else
                exp_1 = false;
            end
            if(~isvector(sq_grid.query_result{1,1,1}))
                if(abs(parameters_range{2}(end-1)*2 - parameters_range{2}(end)) < 10^-10 || abs(parameters_range{2}(end-1)*10 - parameters_range{2}(end)) < 10^-10)
                    exp_2 = true;
                else
                    exp_2 = false;
                end
            end

            if(isvector(sq_grid.query_result{1,1,1}))
                xy_container = XYPlotContainer();
                c = cellfun(@(x) xy_container.store(XYPlot(parameters_range{1}, x, parameters_sweeped{1}, 'Validation error')), sq_grid.query_result(:,1,1), 'UniformOutput', false);
                p = FormatAsMultiplePlots();
                leg = cellfun(@(x) sprintf('Algorithm %s on dataset %s', sq.a_names{a}, x), sq.d_names, 'UniformOutput', false);
                p.displayOnConsole(c, leg, {'Performance'}, true, [exp_1, false]);

            else 
                for d = 1:length(sq.d_names)
                    figure(); hold on; figshift;
                    if(exp_1)
                        set(gca,'xscale','log');
                    end
                    if(exp_2)
                        set(gca,'yscale','log');
                    end
                    surf( parameters_range{1}, parameters_range{2}, sq_grid.query_result{d,1,1}');
                    xlabel(parameters_sweeped{1}{1});
                    ylabel(parameters_sweeped{1}{2});
                    zlabel('Validation error');
                    title(sprintf('Algorithm %s on dataset %s', sq_grid.a_names{1}, sq_grid.d_names{d}));
                end
            end
        
        end
        
    end
    
end