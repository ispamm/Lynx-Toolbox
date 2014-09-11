% InitializeTopology 

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef InitializeTopology < AdditionalFeature
    
    properties
        topology;
        topologies;
        disable_parallel;
        disable_plot;
        distribute_data;
    end
    
    methods
        
        function obj = InitializeTopology(topology, varargin)
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

