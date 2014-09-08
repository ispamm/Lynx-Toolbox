
% INFO_DISTRIBUTEDRVFL Plot information on consensus

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

s = Simulation.getInstance();
algos = find_algorithms('DataDistributedRVFL', s.algorithms);

cons_error = cell(length(s.datasets), length(algos));
primal_residual = cell(length(s.datasets), length(algos));
dual_residual = cell(length(s.datasets), length(algos));
eps_pri = cell(length(s.datasets), length(algos));
eps_dual = cell(length(s.datasets), length(algos));
names_consensus = cell(length(algos), 1);
names_admm = cell(length(algos), 1);
consensus = false(length(algos), 1);
admm = false(length(algos), 1);

fprintf('Information on data-distributed RVFL: see plots.\n');

w = 1;
for i = algos
   
    algo = s.trainedAlgo{1, i, 1}{1};
    if(strcmp(algo.parameters.train_algo{1}, 'consensus') && (algo.parameters.consensus_max_steps > 0))
    
       consensus(w) = true;
       names_consensus{w} = s.algorithms.get(i).name;
       for j = 1:length(s.datasets)

           algo_stats = cell(s.nRuns, 1);

           for z = 1:s.nRuns
               algo_stats{z} = s.trainedAlgo{j, i, z}{1}.statistics;
           end

           algo_stats = sum_structs(algo_stats);
           c = XYPlotContainer();
           cons_error{j, w} = c.store(XYPlot(1:length(algo_stats.consensus_error), algo_stats.consensus_error, ...
               'Iteration', 'Disagreement'));

       end
      
    elseif(strcmp(algo.parameters.train_algo{1}, 'admm'))
        
       admm(w) = true;
       names_admm{w} = s.algorithms.get(i).name;
       for j = 1:length(s.datasets)

           algo_stats = cell(s.nRuns, 1);

           for z = 1:s.nRuns
               algo_stats{z} = s.trainedAlgo{j, i, z}{1}.statistics;
           end

           algo_stats = sum_structs(algo_stats);
           c = XYPlotContainer();
           primal_residual{j, w} = c.store(XYPlot(1:length(algo_stats.r_norm), algo_stats.r_norm, ...
               'Iteration', 'Primal residual norm'));
           c = XYPlotContainer();
           dual_residual{j, w} = c.store(XYPlot(1:length(algo_stats.s_norm), algo_stats.s_norm, ...
               'Iteration', 'Dual residual norm'));
           c = XYPlotContainer();
           eps_pri{j, w} = c.store(XYPlot(1:length(algo_stats.eps_pri), algo_stats.eps_pri, ...
               'Iteration', 'Epsilon (primal)'));
           c = XYPlotContainer();
           eps_dual{j, w} = c.store(XYPlot(1:length(algo_stats.eps_dual), algo_stats.eps_dual, ...
               'Iteration', 'Epsilon (dual)'));

       end

    end
    
    w = w + 1;
   
end

cons_error(:, ~consensus) = [];
names_consensus(~consensus) = [];

primal_residual(:, ~admm) = [];
dual_residual(:, ~admm) = [];
eps_pri(:, ~admm) = [];
eps_dual(:, ~admm) = [];
names_admm(~admm) = [];

p = FormatAsMultiplePlots();

if(~isempty(names_consensus))
    p.displayOnConsole(cons_error, s.datasets.getNames(), names_consensus, false);
end

if(~isempty(names_admm))
    p.displayOnConsole(primal_residual, s.datasets.getNames(), names_admm, false);
    p.displayOnConsole(dual_residual, s.datasets.getNames(), names_admm, false);
    p.displayOnConsole(eps_pri, s.datasets.getNames(), names_admm, false);
    p.displayOnConsole(eps_dual, s.datasets.getNames(), names_admm, false);
end
       