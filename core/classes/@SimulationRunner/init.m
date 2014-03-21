
% INIT Initialize all objects of the simulation

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function obj = init(obj)

    % verbatimFile is the file where all the log of the console is written.
    % It is initially placed in the tmp folder, and eventually moved to the
    % result folder. The actual logging is performed with the diary
    % function of Matlab.
    currentTime = datestr(now, 'yyyymmdd_HHMM');
    obj.verbatimFile = strcat('verbatim_', currentTime, '.txt');
    diary(strcat('tmp/', obj.verbatimFile));
    diary('on');
    
    % Initialization
    fprintf('Initializing simulation...\n');

    % Fill the data structures with the requested configuration
    SimulationLogger.getInstance().clear();
    
    % Load the default configuration, then the user-defined one
    default_config;
    config;
    
    % Copy the configuration from the SimulationLogger object into the
    % current object
    obj = obj.saveConfiguration(simulationName, nRuns, testParameter, seed_prng, output_scripts);
        
    log = SimulationLogger.getInstance();
    
    % In the parallelized mode, output on the console is forbidden
    if(log.flags.parallelized)
        log.flags.debug = false;
    end
   
    % Set Seed and print it on screen
    rng(seed_prng);
    r = rng;
    fprintf('Current seed for prng: %d\n', r.Seed);

    % Open the MATLAB pool if needed
    if matlabpool('size') > 0 && ~log.flags.parallelized % checking to see if pool is already open
        matlabpool('close');
    elseif(matlabpool('size') == 0 && log.flags.parallelized)
        matlabpool('open', 'AttachedFiles', {'./core/classes/SimulationLogger.m'});
    end
    
    % If GPU support is requested, check if the device is supported and
    % then, if successfull, initialize it
    if(log.flags.gpu_enabled && ~log.flags.parallelized)
        check_gpu();
    end
    
    % Hack for parallelization: save the current configuration on each
    % worker
    if(log.flags.parallelized)
        parfor i=1:matlabpool('size')
            init_worker(log);
            if(log.flags.gpu_enabled)
                check_gpu();
            end
        end
    end

    % Check the compatibility of the algorithms with the datasets
    obj = obj.check_compatibility();
    if(~obj.fullCompatibility)
        cprintf('err', 'Statistical testing will not be executed.\n');
    end
    
    % Compute partitions for each run
    for j=1:length(obj.datasets)
        if(log.flags.semisupervised)
            obj.datasets{j} = obj.datasets{j}.generateNPartitions(nRuns, testParameter, semisupervised_holdout);
        else
            obj.datasets{j} = obj.datasets{j}.generateNPartitions(nRuns, testParameter);
        end
        obj.datasets{j} = obj.datasets{j}.shuffle();
    end

    fprintf('End of initialization, will test %i algorithm(s) on %i dataset(s) for %i time(s)\n', length(obj.algorithms), ...
        length(obj.datasets), obj.nRuns);
    
end