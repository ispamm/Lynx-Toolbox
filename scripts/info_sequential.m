% INFO_SEQUENTIAL Print information on sequential learning algorithms

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it


s = Simulation.getInstance();
algoIndexes = find_algorithms('SequentialLearningAlgorithm', s.algorithms);

nFound = length(algoIndexes);
assert(nFound > 0, 'No SequentialLearningAlgorithm algorithms found');

% Get averaged statistics
stats = cell(nFound, length(s.datasets), s.nRuns);
for i=1:nFound
    for d = 1:length(s.datasets)
        for j = 1:s.nRuns
            currentAlgo = s.trainedAlgo(d, algoIndexes(i), j);
            stats{i, d, j} = currentAlgo{1}{1}.statistics;
        end
    end
end

for d = 1:length(s.datasets)
    algoStats = cell(nFound, 1);
    for i=1:nFound
        algoStats{i} = sum_structs(stats(i, d, :));
    end
    
    algoNames = cell(nFound, 1);
    for i = 1:nFound
        algoNames{i} = s.algorithms.get(algoIndexes(i)).name;
    end
    
    plot_field(algoStats, 'error_history', 'Testing Error', {'Batch index', 'Testing error'}, algoNames);
    
end