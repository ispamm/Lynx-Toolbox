% INFO_HIERARCHICAL_ALGORITHM Print information on any hierarchical
% learning algorithm in the simulation.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

s = Simulation.getInstance();
algos = find_algorithms('HierarchicalLearningAlgorithm', s.algorithms);

for i = algos
   cprintf('*text', 'Algorithm %s (first run): \n', s.algorithms.get(i).name);

       algo = s.trainedAlgo{1, i, 1}{1};
       algo.print();

   fprintf('\n');
   
end