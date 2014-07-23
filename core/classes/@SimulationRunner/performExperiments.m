
% PERFORMEXPERIMENTS Test in turn each algorithm on every dataset

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function obj = performExperiments(obj)

N_algo = length(obj.algorithms);
N_datasets = length(obj.datasets);

% Compute all possible combinations of algorithms, datasets and runs
experiments = combvec(1:obj.nRuns, 1:N_datasets, 1:N_algo);
N_experiments = size(experiments, 2);

% The resulting structures are linear because of the necessity of indexing
% inside the parfor
computedError = zeros(N_experiments,1);
trainingTime = zeros(N_experiments,1);
computedError_std = zeros(N_experiments,1);
trainingTime_std = zeros(N_experiments,1);
trainedAlgo = cell(1, N_experiments);

fprintf('\n');
fprintf('--------------------------------------------------\n');
fprintf('--- TRAINING PHASE -------------------------------\n');
fprintf('--------------------------------------------------\n');

log = SimulationLogger.getInstance();

% Initialize progress bars (only in the non-parallelized case)
if(~(log.flags.parallelized))
    statusbar(0, 'Processing %d of %d (%.1f%%)...', 0, 0, 0);
end

parfor i=1:N_experiments
   
    % Get current configuration
    currentConfiguration = experiments(:, i);
    r_id = currentConfiguration(1);
    d_id = currentConfiguration(2);
    a_id = currentConfiguration(3);
    
    % Update GUI
    if(~(log.flags.parallelized))
        sb = statusbar(0, 'Processing %d of %d (%.1f%%)...', N_experiments - i + 1, N_experiments, (N_experiments - i + 1)*100/N_experiments);
    end
    
    % Get the current dataset
    currentDataset = obj.datasets{d_id};
    
    
    % Set the current partition
    currentDataset = currentDataset.setCurrentPartition(r_id);
    
    % Get the current algorithm
    currentAlgo = obj.algorithms(a_id);
    
    % Printing information on screen
    if(log.flags.parallelized)
        t = getCurrentTask();
        fprintf('Evaluating %s on %s (run %d/%d) [Worker %i] ', currentAlgo.name, currentDataset.name, obj.nRuns + 1 - r_id, obj.nRuns, t.ID);
    else
        fprintf('Evaluating %s on %s (run %d/%d) ', currentAlgo.name, currentDataset.name,  obj.nRuns + 1 - r_id, obj.nRuns);
    end
    
    % Printing semi-supervised information
    if(log.flags.semisupervised && currentAlgo.model.isOfClass('SemiSupervisedLearningAlgorithm'))
        [~, ~, ~, ~, Xu, ~] = currentDataset.getFold(1);
    	cprintf('comment', '[Semi-supervised mode, %d unlabeled samples]\n', size(Xu, 1));
    else
        fprintf('\n');
    end
    
    % Train and test
    [tmp1, tmp2, model] ...
        = eval_algo( currentAlgo.model, currentDataset, ~log.flags.parallelized, true );
    
    % Save error, traning time and resulting model
    computedError(i) = mean(tmp1);
    trainingTime(i) = mean(tmp2);
    computedError_std(i) = std(tmp1);
    trainingTime_std(i) = std(tmp2);
    trainedAlgo{i} = model;
    
    if(computedError(i) == Inf)
        cprintf('err', '\t\t Not Allowed\n');
    end
    
end

% Now we need to reconstruct the reshaped matrices
computedError_new = zeros(N_algo, N_datasets, obj.nRuns);
trainingTime_new = zeros(N_algo, N_datasets, obj.nRuns);
computedError_std_new = zeros(N_algo, N_datasets, obj.nRuns);
trainingTime_std_new = zeros(N_algo, N_datasets, obj.nRuns);
trainedAlgo_new = cell(N_algo, N_datasets, obj.nRuns);
for i=1:N_experiments
    computedError_new(experiments(3,i), experiments(2,i), experiments(1,i)) = computedError(i);
    trainingTime_new(experiments(3,i), experiments(2,i), experiments(1,i)) = trainingTime(i);
    computedError_std_new(experiments(3,i), experiments(2,i), experiments(1,i)) = computedError_std(i);
    trainingTime_std_new(experiments(3,i), experiments(2,i), experiments(1,i)) = trainingTime_std(i);
    trainedAlgo_new{experiments(3,i), experiments(2,i), experiments(1,i)} = trainedAlgo(i);
end
obj.computedError = computedError_new;
obj.trainingTime = trainingTime_new;
obj.computedError_std = computedError_std_new;
obj.trainingTime_std = trainingTime_std_new;
obj.trainedAlgo = trainedAlgo_new;

fprintf('\n');

end