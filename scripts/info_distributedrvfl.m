
% INFO_DISTRIBUTEDRVFL Plot information on DataDistributedRVFL and
% SerialDataDistributedRVFL

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

% Initialize required objects
s = Simulation.getInstance();
xy_container = XYPlotContainer();
p = FormatAsMultiplePlots();

fprintf('Information on data-distributed RVFL: see plots.\n\n');

% Filter by algorithms
sq = StatisticsQuery(s);
sq = sq.filterByAlgorithmClass({'DataDistributedRVFL', 'SerialDataDistributedRVFL'}).averageByRun();

% Print information on consensus steps
sq_cons = sq.filterByBooleanCondition(@(x) strcmp(x.parameters.train_algo{1}, 'consensus') && (x.parameters.consensus_max_steps > 0)). ...
     query({'consensus_error'});
if(~isempty(sq_cons.query_result))
    fprintf('Average number of consensus iterations (train_algo = ''consensus''):\n');
    disptable(sum(sq_cons.convertToMatrix().query_result ~= 0, 3), sq_cons.a_names, sq_cons.d_names);
    
    % Plot consensus error
    cons_plot = cellfun(@(x) xy_container.store(XYPlot(1:length(x), x, 'Iteration', 'Disagreement')), ...
        sq_cons.query_result, 'UniformOutput', false);
    p.displayOnConsole(cons_plot, sq_cons.d_names, sq_cons.a_names, false);
    
end

% Print information on ADMM steps
sq_admm = sq.filterByBooleanCondition(@(x) strcmp(x.parameters.train_algo{1}, 'admm')).averageByRun();;
sq_admm_steps = sq_admm.query({'r_norm'}).convertToMatrix();
if(~isempty(sq_admm.query_result))
    fprintf('Average number of ADMM iterations (train_algo = ''admm''):\n');
    disptable(sum(sq_admm.query_result ~= 0, 3), sq_admm.a_names, sq_admm.d_names)
end

% Plot information on ADMM
r_norm = sq_admm.query({'r_norm'}).convertToMatrix().query_result;
s_norm = sq_admm.query({'s_norm'}).convertToMatrix().query_result;
eps_pri = sq_admm.query({'eps_pri'}).convertToMatrix().query_result;
eps_dual = sq_admm.query({'eps_dual'}).convertToMatrix().query_result;
admm_steps = size(r_norm, 3);

prim_plot = cell(length(sq_admm.d_names), length(sq_admm.a_names)*2);
dual_plot = cell(length(sq_admm.d_names), length(sq_admm.a_names)*2);
legend_pri = cell(length(sq_admm.a_names)*2, 1);
legend_dual = cell(length(sq_admm.a_names)*2, 1);

for i = 1:length(sq_admm.a_names)
    for j = 1:length(sq_admm.d_names)
        prim_plot{j, 2*(i-1)+1} = xy_container.store(XYPlot(1:admm_steps, squeeze(r_norm(j, i, :)), ...
            'Iteration', 'Norm'));
        prim_plot{j, 2*(i-1)+2} = xy_container.store(XYPlot(1:admm_steps, squeeze(eps_pri(j, i, :)), ...
            'Iteration', 'Norm'));
        dual_plot{j, 2*(i-1)+1} = xy_container.store(XYPlot(1:admm_steps, squeeze(s_norm(j, i, :)), ...
            'Iteration', 'Norm'));
        dual_plot{j, 2*(i-1)+2} = xy_container.store(XYPlot(1:admm_steps, squeeze(eps_dual(j, i, :)), ...
            'Iteration', 'Norm'));
    end
    legend_pri{2*(i-1)+1} = sprintf('%s - Primal Residual', sq_admm.a_names{i});
    legend_pri{2*(i-1)+2} = sprintf('%s - Epsilon', sq_admm.a_names{i});
    legend_dual{2*(i-1)+1} = sprintf('%s - Dual Residual', sq_admm.a_names{i});
    legend_dual{2*(i-1)+2} = sprintf('%s - Epsilon', sq_admm.a_names{i});
end

p.displayOnConsole(prim_plot, sq_admm.d_names, legend_pri, false);
p.displayOnConsole(dual_plot, sq_admm.d_names, legend_dual, false);