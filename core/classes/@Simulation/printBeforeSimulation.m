
% printBeforeSimulation - Print the details of the simulation on screen

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function printBeforeSimulation(obj)

fprintf('--------------------------------------------------\n');
fprintf('--- DETAILS --------------------------------------\n');
fprintf('--------------------------------------------------\n');

% Print details on the algorithms
cprintf('-text', 'Algorithms included in the simulation (%i total):\n', length(obj.algorithms));

for i = 1:length(obj.algorithms)
    fprintf('\t * %s \n \t   --> %s\n', obj.algorithms.get(i).name, obj.algorithms.get(i).getInstanceDescription());
end
fprintf('\n');

% Print details on the datasets
cprintf('-text', 'Datasets selected for the simulation (%i total):\n', length(obj.datasets));

for i = 1:length(obj.datasets)
    d = obj.datasets.get(i);
    t = Tasks.getById(d.task);
    fprintf('\t * %s (%s) - %s\n', d.name, t.getDescription(), d.getDescription());
end

fprintf('\n');

% List the selected performance measures
cprintf('-text', 'The following performance measures have been selected:\n');

PerformanceEvaluator.getInstance().printDetailOfPerformanceMeasures();

fprintf('\n');

% List a few additional details, including the PRNG seed, the number of
% experiments, the partition strategy, and so on.
cprintf('-text', 'Additional details :\n');

log = SimulationLogger.getInstance();

r = rng;
fprintf('\t * Current seed for prng: %d\n', r.Seed);

fprintf('\t * Will repeat experiments %i time(s) with partitioning %s\n', obj.nRuns, class(obj.partition_strategy));
if(log.flags.semisupervised)
    fprintf('\t * Will run in semi-supervised mode\n');
end
if(log.flags.parallelized)
    fprintf('\t * Will run in a cluster configuration\n');
end

if(~isempty(obj.additionalFeatures))
    fprintf('\t * The following features are active: \n');
    for i = 1:length(obj.additionalFeatures)
        fprintf('\t\t --> %s (%s) \n', class(obj.additionalFeatures{i}), obj.additionalFeatures{i}.getDescription());
    end
end

fprintf('\n');

% Ask for user confirmation before starting the simulation
result = '';
while(~strcmpi(result, 'y') && ~strcmpi(result, 'n'))
    cprintf('*text', 'Start simulation? (Y/N)\n');
    result = input('', 's');
end
if(strcmpi(result, 'N'))
    error('Lynx:Runtime:AbortedByUser', 'The simulation has been aborted by the user');
end

end

