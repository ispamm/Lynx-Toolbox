
% INFO_DISTRIBUTEDRVFL Plot information on consensus

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

s = Simulation.getInstance();
algos = find_algorithms('DataDistributedRVFL', s.algorithms);
algos = [algos; find_algorithms('SerialDataDistributedRVFL', s.algorithms)];

cons_error = cell(length(s.datasets), length(algos));
primal_residual = cell(length(s.datasets), length(algos)*2);
dual_residual = cell(length(s.datasets), length(algos)*2);
cons_steps = cell(length(s.datasets), length(algos));
names_consensus = cell(length(algos), 1);
names_admm = cell(length(algos), 1);
consensus = false(length(algos), 1);
admm = false(length(algos), 1);

fprintf('Information on data-distributed RVFL: see plots.\n');

w = 1;
zz = 1;

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
        
           fprintf('Average number of consensus iterations on dataset %s: %i\n', s.datasets.get(j).name, sum(algo_stats.consensus_error~=0));
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
           primal_residual{j, 2*(zz-1)+1} = c.store(XYPlot(1:length(algo_stats.r_norm), algo_stats.r_norm, ...
               'Iteration', 'Norm'));
           primal_residual{j, 2*(zz-1)+2} = c.store(XYPlot(1:length(algo_stats.eps_pri), algo_stats.eps_pri, ...
               'Iteration', 'Norm'));
           
           c = XYPlotContainer();
           dual_residual{j, 2*(zz-1)+1} = c.store(XYPlot(1:length(algo_stats.s_norm), algo_stats.s_norm, ...
               'Iteration', 'Norm'));
           c = XYPlotContainer();
           dual_residual{j, 2*(zz-1)+2} = c.store(XYPlot(1:length(algo_stats.eps_dual), algo_stats.eps_dual, ...
               'Iteration', 'Norm'));
           
           c = XYPlotContainer();
           dual_residual{j, 2*(zz-1)+1} = c.store(XYPlot(1:length(algo_stats.s_norm), algo_stats.s_norm, ...
               'Iteration', 'Norm'));
           c = XYPlotContainer();
           dual_residual{j, 2*(zz-1)+2} = c.store(XYPlot(1:length(algo_stats.eps_dual), algo_stats.eps_dual, ...
               'Iteration', 'Norm'));

           c = XYPlotContainer();
           cons_steps{j, w} = c.store(XYPlot(1:length(algo_stats.consensus_steps), algo_stats.consensus_steps, ...
               'Iteration', 'Consensus iterations in ADMM'));
           
           fprintf('Average number of ADMM iterations on dataset %s: %i\n', s.datasets.get(j).name, sum(algo_stats.r_norm~=0));
           fprintf('Average number of ADMM consensus iterations on dataset %s: %i\n', s.datasets.get(j).name, sum(algo_stats.consensus_steps));
           
       end
       
       zz = zz + 2;

    end
    
    w = w + 1;
   
end

cons_error(:, ~consensus) = [];
names_consensus(~consensus) = [];

primal_residual(:, zz+1:end) = [];
dual_residual(:, zz+1:end) = [];
cons_steps(:, ~admm) = [];
names_admm(~admm) = [];

p = FormatAsMultiplePlots();

if(~isempty(names_consensus))
    p.displayOnConsole(cons_error, s.datasets.getNames(), names_consensus, false);
end
if(~isempty(names_admm))
    legend1 = cell(length(names_admm)*2, 1);
    legend2 = cell(length(names_admm)*2, 1);
    for ii = 1:length(names_admm)
        legend1{2*(ii-1)+1} = sprintf('%s - Primal Residual', names_admm{ii});
        legend1{2*(ii-1)+2} = sprintf('%s - Epsilon', names_admm{ii});
        legend2{2*(ii-1)+1} = sprintf('%s - Dual Residual', names_admm{ii});
        legend2{2*(ii-1)+2} = sprintf('%s - Epsilon', names_admm{ii});
    end
    p.displayOnConsole(primal_residual, s.datasets.getNames(), legend1, false);
    p.displayOnConsole(dual_residual, s.datasets.getNames(), legend2, false);
    p.displayOnConsole(cons_steps, s.datasets.getNames(), names_admm, false);
end
       