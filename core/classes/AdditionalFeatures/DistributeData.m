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
            obj.distributors = containers.Map;
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
            if(~ obj.distributors.iskey(d.id))
                obj.distributors(d.id) = codistributor1d(1, codistributor1d.unsetPartition, size(Xtr, 1));
            end
            dist = distributors(d.id);
            d.X = distribute(d.X, dist);
            d.Y = distribute(d.Y, dist);
            a.topology = obj.topology;
        end
        
        function [a, d] = executeAfterEachExperiment(obj, a, d)
            d.X = gather(d.X);
            d.Y = gather(d.Y);
        end
        
        function executeAfterFinalization(obj)
            fprintf('Network topology: see plot.\n');
            obj.topology.visualize();
            matlabpool('close');
        end
        
        function executeOnError(obj)
            matlabpool('close');
        end
        
        function s = getDescription(~)
            s = strcat('Distribute data according to topology: ', obj.topology.getDescription());
        end
    end
    
end

