
% SIMULATIONRUNNER The main object representing the simulation.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef SimulationRunner
    
    properties
        algorithms;         % A cell array with all the algorithms
        datasets;           % A cell array with all the datasets
        nRuns;              % Number of executions of each test
        partition_strategy; % Partitioning strategy to be used
        seed_prng;          % Seed of the PRNG
        fullCompatibility;  % A boolean indicating if there are inconsistencies
        computedError;      % Final errors
        trainingTime;       % Final training times
        trainedAlgo;        % Final models
        verbatimFile;       % The file with the log of the simulation
        simulationName;     % Name of the simulation
        outputScripts;      % Output scripts to be executed at the end
    end
    
    methods
        
        % See documentation for each method
        
        obj = init(obj);
        obj = check_compatibility(obj);    
        obj = performExperiments(obj);
        obj = formatOutput(obj);
        obj = statisticalTesting(obj);
        obj = saveResults(obj);
        obj = finalizeSimulation(obj);
        obj = executeOutputScripts(obj);
        
        % Load the configuration from the SimulationLogger
        function obj = saveConfiguration(obj, simulationName, nRuns, strategy, seed_prng, output_scripts)
           obj.simulationName = simulationName;
           obj.nRuns = nRuns;
           obj.partition_strategy = strategy;
           obj.seed_prng = seed_prng;
           obj.algorithms = SimulationLogger.getInstance().algorithms;
           obj.datasets = SimulationLogger.getInstance().datasets;
           obj.outputScripts = output_scripts;
        end
        
        % Return only the algorithms names
        function names = getAlgorithmsNames(obj)
           N_algo = length(obj.algorithms);
           names = cell(N_algo, 1);
           for i=1:N_algo
               names{i} = obj.algorithms(i).name;
           end
        end
        
        % Return only the datasets names
        function names = getDatasetsNames(obj)
           N_algo = length(obj.datasets);
           names = cell(N_algo, 1);
           for i=1:N_algo
               names{i} = obj.datasets{i}.name;
           end
        end

    end
    
end

