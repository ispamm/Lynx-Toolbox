% DistributeData 

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef DistributeData < AdditionalFeature
    
    properties
        topology;
    end
    
    methods
        
        function obj = DistributeData(topology)
            obj.topology = topology;
        end
        
        function executeAfterInitialization(obj)
            
            % Check if we are in parallel mode
            log = SimulationLogger.getInstance();
            if(log.flags.parallelized)
                error('Lynx:Runtime:IncompatibleFeatures', 'Cannot distribute data if already running in a cluster configuration');
            end
            
            % Open the pool of workers
            matlabpool('open');
            
            % Check that there are enough labs
            if(matlabpool('size') < obj.topology.N)
                error('Lynx:Runtime:SmallCluster', 'Maximum number of nodes in this cluster is %i', matlabpool('size'));
            end
            
            check_install_on_cluster();
            
        end
        
        function [a, d] = executeBeforeEachExperiment(obj, a, d)
            if(a.isOfClass('DataDistributedLearningAlgorithm'))
                a.topology = obj.topology;
            end
        end
        
        function [a, d] = executeAfterEachExperiment(obj, a, d)

        end
        
        function executeAfterFinalization(obj)
            fprintf('Network topology: see plot.\n');
            obj.topology.visualize();
        end

        function s = getDescription(obj)
            s = sprintf('Distribute data according to topology: %s', obj.topology.getDescription());
        end
    end
    
end

