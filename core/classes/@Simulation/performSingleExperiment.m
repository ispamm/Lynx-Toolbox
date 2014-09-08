
% performSingleExperiment - Perform a single experiment

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function [p, t, a] = performSingleExperiment(obj, currentConfiguration)

% Get current configuration (run - dataset - algorithm)
r_id = currentConfiguration(1);
d_id = currentConfiguration(2);
a_id = currentConfiguration(3);

% Get the current dataset
currentDataset = obj.datasets.get(d_id);

% Set the current partition
currentDataset = currentDataset.setCurrentPartition(r_id);

% Get the current algorithm
currentAlgo = obj.algorithms.get(a_id);

% Set the current run on the logger
log = SimulationLogger.getInstance();
log.setAdditionalParameter('run', r_id);

% Printing information on screen
log = SimulationLogger.getInstance();
if(log.flags.parallelized)
    t = getCurrentTask();
    fprintf('Evaluating %s on %s (run %d/%d) [Worker %i] ', currentAlgo.name, currentDataset.name, obj.nRuns + 1 - r_id, obj.nRuns, t.ID);
else
    fprintf('Evaluating %s on %s (run %d/%d) ', currentAlgo.name, currentDataset.name,  r_id, obj.nRuns);
end

% Printing semi-supervised information
if(log.flags.semisupervised && currentAlgo.isOfClass('SemiSupervisedLearningAlgorithm'))
    [~, ~,Xu] = currentDataset.getFold(1);
    cprintf('comment', '[Semi-supervised mode, %d unlabeled samples]\n', size(Xu, 1));
else
    fprintf('\n');
end

% Execute custom features
for z = 1:length(obj.additionalFeatures)
    [currentAlgo, currentDataset] = obj.additionalFeatures{z}.executeBeforeEachExperiment(currentAlgo, currentDataset);
end

% Get the current performance evaluator object
p = PerformanceEvaluator.getInstance();

% Train and test
[p, t, a] = ...
    p.computePerformance(currentAlgo, currentDataset, true );
if(isempty(a))
    cprintf('err', '\t\t Not Allowed\n');
end

% Execute custom features
for z = 1:length(obj.additionalFeatures)
    [currentAlgo, currentDataset] = obj.additionalFeatures{z}.executeAfterEachExperiment(currentAlgo, currentDataset);
end

end