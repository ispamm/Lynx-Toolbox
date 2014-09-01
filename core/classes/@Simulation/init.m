
% init - Initialize the simulation
%   This includes: (i) loading the configuration file, (ii) enabling the 
%   matlabpool, (iii) checking the prerequisites for every algorithm, (iv) 
%   initializing the partitions, (v) running the required methods for the
%   custom features.
%
% See also: AdditionalFeature

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function obj = init(obj)

    % Initialization
    fprintf('Initializing simulation...\n');
    
    % Clear all singleton objects
    SimulationLogger.getInstance().clear();
    PerformanceEvaluator.getInstance().clear();
    tasks = Tasks.getAllTasks();
    for i = 1:length(tasks)
        tasks{i}.clear();
    end
    
    % Load the the user-defined configuration
    defaultConfig = fullfile(XmlConfiguration.getRoot(), 'config.m');
    if(exist(defaultConfig, 'file') == 2)
        fprintf('Loading default configuration file...\n');
        obj.configFile = defaultConfig;
        config;
    else
        obj.askForConfigurationFile();
    end
    
    % Execute custom features
    for i = 1:length(obj.additionalFeatures)
        obj.additionalFeatures{i}.executeBeforeInitialization();
    end
    
    % Preallocate cell arrays for performance measures and training times
    log = SimulationLogger.getInstance();
    obj.performanceMeasures = cell(length(obj.datasets), length(obj.algorithms));
    obj.trainingTimes = cell(length(obj.datasets), length(obj.algorithms));

    % Check prerequisites of every algorithm
    fprintf('Checking prerequisites...\n');
    for i = 1:length(obj.algorithms)
        o = obj.algorithms.get(i);
        b = o.checkForPrerequisites();
        if(~b)
            error('Lynx:Runtime:MissingLibrary', 'A required library or toolbox is missing');
        end
    end
    
    % Check the compatibility of the algorithms with the datasets
    obj = obj.check_compatibility();
    
    % Compute partitions for each run
    for j=1:length(obj.datasets)
        if(log.flags.semisupervised)
            obj.datasets = obj.datasets.set(j, obj.datasets.get(j).generateNPartitions(obj.nRuns, obj.partition_strategy, obj.ss_partition));
        else
            obj.datasets = obj.datasets.set(j, obj.datasets.get(j).generateNPartitions(obj.nRuns, obj.partition_strategy));
        end
    end

    % Open the MATLAB pool if needed
    if matlabpool('size') > 0 && ~log.flags.parallelized % checking to see if pool is already open
        matlabpool('close');
    elseif(matlabpool('size') == 0 && log.flags.parallelized)
        matlabpool('open');
    end

    % In the parallelized mode, output on the console is forbidden
    if(log.flags.parallelized)
        log.flags.debug = false;
        
        % Hack for parallelization
        % Fill the data structures with the requested configuration
        s = SimulationLogger.getInstance();
        sim = Simulation.getInstance();
        p = PerformanceEvaluator.getInstance();
        parfor i=1:matlabpool('size')  
            init_worker(s, @()SimulationLogger.getInstance());
            init_worker(sim, @()Simulation.getInstance());
            init_worker(p, @()PerformanceEvaluator.getInstance());
        end
    end
    
    % Execute custom features
    for i = 1:length(obj.additionalFeatures)
        obj.additionalFeatures{i}.executeAfterInitialization();
    end
    
    % Print the details of the simulation
    obj.printBeforeSimulation();
    
end