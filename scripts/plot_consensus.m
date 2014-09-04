
% PLOT_CONSENSUS Plot information on consensus

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

s = Simulation.getInstance();
algos = find_algorithms('DataDistributedLearningAlgorithm', s.algorithms);

cons_error = cell(length(s.datasets), length(algos));
names = cell(length(algos), 1);

fprintf('Consensus iteration: see plots\n');

for i = algos
   
   names{i} = s.algorithms.get(algos(i)).name;
   for j = 1:length(s.datasets)
       
       algo_stats = cell(s.nRuns, 1);
       
       for z = 1:s.nRuns
           algo_stats{z} = s.trainedAlgo{j, i, z}{1}.statistics;
       end
       
       algo_stats = sum_structs(algo_stats);
       c = XYPlotContainer();
       cons_error{j, i} = c.store(XYPlot(algo_stats.consensus_error, 1:length(algo_stats.consensus_error), ...
           'Iteration', 'Disagreement'));

   end
   
end
    
p = FormatAsMultiplePlots();
p.displayOnConsole(cons_error, s.datasets.getNames(), names);
       