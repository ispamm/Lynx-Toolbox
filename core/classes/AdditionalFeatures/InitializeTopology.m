% InitializeTopology - Initialize a topology of agents
%   This feature is needed whenever you use a DistributedLearningAlgorithm,
%   and it is used to initialize the topology of the network of agents. Use
%   it as:
%
%   add_feature(InitializeTopology(t));
%
%   where t is a suitable NetworkTopology. This has different behaviors
%   depending on suitable flags:
%
%   1) By default, it opens an SPMD block. To simply simulate a parallel
%   situation (see for example SerialDistributedRVFL), add the additional
%   flag disable_parallel:
%
%       add_feature(InitializeTopology(t), 'disable_parallel');
%
%   2) To distribute the training dataset across the nodes, add the flag
%   distribute_data:
%
%       add_feature(InitializeTopology(t), 'distribute_data');
%
%   In parallel mode, this is split using codistributed arrays. In
%   non-parallel mode, this is split using a simpler KFoldPartition.
%
%   3) At the end of the simulation, the network topologies are shown on
%   the screen. To disable this, add the flag disable_plot:
%
%       add_feature(InitializeTopology(t), 'disable_plot');

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef InitializeTopology < AdditionalFeature
    
    properties
        topology;           % Network topology
        topologies;         % Cell array of topologies for every run
        disable_parallel;   % Flag for disabling parallel mode
        disable_plot;       % Flag for disabling plot
        distribute_data;    % Flag for distributing data
    end
    
    methods
        
        function obj = InitializeTopology(topology, varargin)
            % Construct the feature
            obj.topology = topology;
            obj.disable_parallel = any(strcmp(varargin, 'disable_parallel'));
            obj.disable_plot = any(strcmp(varargin, 'disable_plot'));
            obj.distribute_data = any(strcmp(varargin, 'distribute_data'));
        end
        
        function executeAfterInitialization(obj)
            
            % Initialize the topologies
            s = Simulation.getInstance();
            obj.topologies = cell(s.nRuns, 1);
            for i = 1:s.nRuns
                obj.topologies{i} = obj.topology.initialize();
            end
            
            % Check if we are in parallel mode
            log = SimulationLogger.getInstance();
            if(log.flags.parallelized && ~(obj.disable_parallel))
                error('Lynx:Runtime:IncompatibleFeatures', 'Cannot distribute data if already running in a cluster configuration');
            end
            
            if(~obj.disable_parallel)
                
                % Open the pool of workers
                matlabpool('open');
                % Check that there are enough labs
                if(matlabpool('size') < obj.topology.N)
                    error('Lynx:Runtime:SmallCluster', 'Maximum number of nodes in this cluster is %i', matlabpool('size'));
                end

                check_install_on_cluster();
                
            end
            
        end
        
        function [a, d] = executeBeforeEachExperiment(obj, a, d)
            % Set the topology and the flags on the algorithm
            if(a.isOfClass('DistributedLearningAlgorithm'))
                log = SimulationLogger.getInstance();
                a.topology = obj.topologies{log.getAdditionalParameter('run')};
                a.distribute_data = obj.distribute_data;
                a.parallelized = ~(obj.disable_parallel);
            end
        end
        
        function [a, d] = executeAfterEachExperiment(obj, a, d)
        end
        
        function executeBeforeFinalization(obj)
            % Eventually plot the topologies
            if(~obj.disable_plot)
                fprintf('Network topology: see plot.\n');
                for i = 1:length(obj.topologies)
                    obj.topologies{i}.visualize(sprintf('Network topology for run %i', i));
                end
            end
        end

        
        
        function s = getDescription(obj)
            s = sprintf('Initialize topology: %s', obj.topology.getDescription());
        end
    end
    
end

