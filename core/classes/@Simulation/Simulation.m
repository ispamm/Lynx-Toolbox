
% Simulation - The main object representing the simulation
%   This is a Singleton object, which can be retrieved only using the
%   getInstance method. See the run_configuration script for the order of
%   execution of every method.
%
% See also: SingletonClass

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef Simulation < SingletonClass
    
    properties(Access=protected,Constant)
        singleton_id = 'simulation_obj';
    end
    
    properties
        algorithms;         % A CustomContainer with all the algorithms
        datasets;           % A CustomContainer with all the datasets
        nRuns;              % Number of executions of each test
        partition_strategy; % Partitioning strategy to be used
        ss_partition;       % Partitioning strategy for semi-supervised trainining
        seed_prng;          % Seed of the PRNG
        trainedAlgo;        % Final models
        fullCompatibility;  % Whether there are inconsistencies
        performanceMeasures;% Performance measures
        trainingTimes;      % Training times
        additionalFeatures; % Cell array of additional features
        configFile;         % Configuration file;
    end
    
    methods(Access=protected)
        function obj = Simulation()
            % Initialize the Simulation object with some default parameters
            obj = obj@SingletonClass();
            obj.algorithms = CustomContainer();
            obj.datasets = CustomContainer();
            obj.nRuns = 1;
            obj.partition_strategy = KFoldPartition(3);
            obj.ss_partition = HoldoutPartition(0.25);
            obj.seed_prng = 'shuffle';
            obj.additionalFeatures = {};
        end
    end
    
    methods (Static)
      function singleObj = getInstance()
         singleObj = SingletonClass.getInstanceFromClass(Simulation());
      end
    end

    methods

        % See documentation for each method
        
        % Initialize the simulation
        obj = init(obj);
        
        % Check that algorithms and datasets are compatible
        obj = check_compatibility(obj);    
        
        % Perform all the experiments
        obj = performExperiments(obj);
        
        % Perform a single experiment
        [p, t, a] = performSingleExperiment(obj, currentConfiguration);
        
        % Display the results
        obj = formatOutput(obj);
        
        % Finalize the simulation
        obj = finalizeSimulation(obj);
        
        % Ask for a configuration file
        obj = askForConfigurationFile(obj);

    end
    
end

