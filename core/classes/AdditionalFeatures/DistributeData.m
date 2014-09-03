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
            check_install_on_cluster();
            
        end
        
        function [a, d] = executeBeforeEachExperiment(obj, a, d)
            if(a.isOfClass('DataDistributedLearningAlgorithm'))
                spmd(obj.topology.N)
                    d.X = codistributed(d.X, codistributor1d(1));
                    d.Y = codistributed(d.Y, codistributor1d(1));
                end
                d = d{1};
                a.topology = obj.topology;
            end
        end
        
        function [a, d] = executeAfterEachExperiment(obj, a, d)
            if(a.isOfClass('DataDistributedLearningAlgorithm'))
                d.X = gather(d.X);
                d.Y = gather(d.Y);
            end
        end
        
        function executeAfterFinalization(obj)
            fprintf('Network topology: see plot.\n');
            obj.topology.visualize();
            matlabpool('close');
        end

        function s = getDescription(obj)
            s = sprintf('Distribute data according to topology: %s', obj.topology.getDescription());
        end
    end
    
end

