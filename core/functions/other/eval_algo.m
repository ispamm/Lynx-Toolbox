% EVAL_ALGO  Evaluate an algorithm on a dataset. The partition is given by 
% the user.
%
%   [ERR TIME ALGO] = EVAL_ALGO(ALGO, DATASET, CP, VERBOSE, SAVEFOLD) Train
%   and test algorithm ALGO on dataset DATASET, using the cvpartition CP.
%   ERR is a vector of errors computed on the dataset, and TIME a vector of
%   training times. ALGO is the update algorithm structure. VERBOSE is a
%   boolean indicating whether the method should print on screen
%   information, while SAVEFOLD is a boolean indicating whether it should
%   save the current fold inside the Logger.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function [ err, trainingTime, algo ] = eval_algo( algo, dataset, verbose, saveFold )

if(nargin < 4)
    saveFold = false;
end
if(nargin < 3)
    verbose = false;
end

folds = dataset.folds();

p = SimulationLogger.getInstance.performanceMeasures(char(dataset.task));
p = p();

% Needed for the GA feature search
if(isempty(dataset.X))
    err = Inf;
    trainingTime = 0;
    return;
end

% Check if the current task is allowed
if(~algo.isTaskAllowed(dataset.task))
    err = Inf;
    trainingTime = 0;
    return;
end

log = SimulationLogger.getInstance();

err = zeros(1, folds);
trainingTime = zeros(1, folds);
t_params = cell(1, folds);
s_params = cell(1, folds);

for ii = 1:folds

    if(saveFold)
        log.setAdditionalParameter('fold', ii);
        log.setAdditionalParameter('dataset_id', dataset.id);
        log.setAdditionalParameter('dataset_name', dataset.name);
        log.setAdditionalParameter('run', dataset.currentPartition);
    else
        try
            kernelType = algo.getTrainingParam('kernel_type');
            if(strcmp(kernelType, 'custom'))
                dataset.isKernelMatrix = true;
            end
        catch
        end
    end
    
    algo = algo.setTask(dataset.task);
    t = clock;

    [Xtrn, Ytr, Xtst, Ytst, Xu, Yu] = dataset.getFold(ii);
    
    if(verbose)
        fprintf('\t%s', dataset.getFoldInformation(ii));
    end
    
    if(saveFold)
        log.setAdditionalParameter('Xu', Xu);
    end
    
    algo = algo.train(Xtrn, Ytr);
    trainingTime(ii) = etime(clock, t);
    
    [labels, ~] = algo.test(Xtst);
    
    if(any(labels ~= 0))
        err(ii) = p.compute(Ytst, labels);
    else
        err(ii) = NaN;
    end
    
    if(~isempty(Xu) && saveFold)
        algo.statistics.unlabeled_accuracy = p.compute(Yu, algo.test(Xu));
    end
    
    algo.trainingParams = algo.getTrainingParams();
    algo.statistics = algo.getStatistics();
    
    t_params{ii} = algo.getTrainingParams();
    s_params{ii} = algo.getStatistics();
    
end

% The overall trainingParams and statistics are averaged over the folds
algo.trainingParams = sum_structs(t_params);
algo.statistics = sum_structs(s_params);

end