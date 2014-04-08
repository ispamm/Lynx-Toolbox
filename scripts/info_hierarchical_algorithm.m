
% INFO_HIERARCHICAL_ALGORITHM Print information on any hierarchical
% learning algorithm in the simulation.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

algos = find_algorithms('HierarchicalLearningAlgorithm', obj.algorithms);

for i = algos
   cprintf('*text', 'Algorithm %s (first run): \n', obj.algorithms(i).name);
   
   for j = 1:length(obj.datasets)
       
       fprintf('\tDataset %s:\n\n', obj.datasets{j}.name);
       
       algo = obj.trainedAlgo{i, j, 1}{1};
       algo.print();
       
   end
   
   fprintf('\n');
   
end
    