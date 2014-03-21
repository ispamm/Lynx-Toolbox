
% INFO_GP_KERNELSEARCH Print information about GP-based kernel search

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

PRINT_KERNELS = true;
PRINT_GRAPHS = true;

assert(length(obj.datasets) == 1, 'Can only print information for a run with a single dataset');

% Search the GP-based algorithms
gpalgoIndexes = find_algorithms('Kernelsearch_GP', obj.algorithms);

nFound = length(gpalgoIndexes);
assert(nFound > 0, 'No Kernelsearch_GP algorithms found');

% Get averaged statistics
stats = cell(nFound, obj.nRuns);
for i=1:nFound
    currentAlgo = squeeze(obj.trainedAlgo(gpalgoIndexes(i), 1, :));
    for j = 1:obj.nRuns
        stats{i,j} = currentAlgo{j}{1}.statistics;
    end
end

if(PRINT_KERNELS)
    
    % Print the best kernels
    fprintf('Best kernels:\n');

    for i=1:nFound
        fprintf('\t Algorithm: %s\n', obj.algorithms(gpalgoIndexes(i)).name);
        
        for j = 1:obj.nRuns
            if(iscell(stats{i,j}.best_ind))
               fprintf('\t\t Run %d:\n', j);
               for z=1:length(stats{i,j}.best_ind)
                  fprintf('\t\t\t Fold %d: %s\n', z, stats{i,j}.best_ind{z}.print());
               end
            else
                fprintf('\t\t Run %d: %s\n', j, stats{i,j}.best_ind.print());
            end
        end
        
    end

end

if(PRINT_GRAPHS)

    algoStats = cell(nFound, 1);
    for i=1:nFound
        algoStats{i} = sum_structs(stats(i, :));
    end
    
    algoNames = cell(nFound, 1);
    for i = 1:nFound
        algoNames{i} = obj.algorithms(gpalgoIndexes(i)).name;
    end
    
    cmap = plot_field(algoStats, 'best_fitness', 'Best fitness evolution', {'Generation', 'Best fitness'}, algoNames);
    plot_field(algoStats, 'average_fitness', 'Average Fitness evolution', {'Generation', 'Average fitness'}, algoNames, cmap);
    plot_field(algoStats, 'entropy', 'Entropy evolution', {'Generation', 'Entropy'}, algoNames, cmap);
    plot_field(algoStats, 'edit_distance', 'Edit Distance evolution', {'Generation', 'Edit Distance'}, algoNames, cmap);
    plot_field(algoStats, 'phen_diversity', 'Phenotipic Diversity evolution', {'Generation', 'Phenotipic Diversity'}, algoNames, cmap);
    plot_field(algoStats, 'sharing_factor', 'Sharing Factor evolution', {'Generation', 'Sharing Factor'}, algoNames, cmap);
    
end

clear PRINT_KERNELS PRINT_GRAPHS gpalgoIndexes nFound folds currentAlgo cmap algoNames