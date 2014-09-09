% NetworkNode - 
classdef NetworkNode
    
    properties
        topology;
    end
    
    methods
        function obj = NetworkNode()
        end
        
        function obj = set_topology(t)
            obj.topology = t;
        end
        
       function idx = getNeighbors(obj, i)
           idx = obj.topology.getNeighbors(i);
       end
        
        function [final_value, consensus_error] = run_consensus(obj, initial_value, steps, threshold)
            % Execute consensus algorithm
            
            if(isempty(getCurrentWorker()))
                error('Lynx:Runtime:Parallel', 'Consensus algorithm must be executed inside an SPMD block');
            end
            
            current_value = initial_value;
            consensus_error = zeros(steps, 1);
            for ii = 1:steps
                idx = obj.getNeighbors(labindex);
                new_value = current_value;
                for jj = 1:length(idx)
                    neighbor_property = labSendReceive(idx(jj), idx(jj), current_value);
                    %consensus_error(ii) = consensus_error(ii) + norm(current_value - neighbor_property);
                    new_value = new_value + neighbor_property;
                end
                old_value = current_value;
                current_value = new_value./(length(idx) + 1);
                consensus_error(ii) = norm(current_value - old_value);
            end
            final_value = current_value;
        end
        
        function [final_value, consensus_error] = run_consensus_serial(obj, initial_values, steps, threshold)
            
            current_values = initial_values;
            consensus_error = zeros(steps, 1);
            
            for ii = 1:steps
                for jj = 1:obj.topology.N
                    idx = obj.getNeighbors(jj);
                    new_value = (current_values(:, jj) + sum(current_values(:, idx), 2))/(length(idx) + 1);
                    consensus_error(ii) = consensus_error(ii) + norm(current_values(:, jj) - new_value);
                    current_values(:, jj) = new_value;
                end
                consensus_error(ii) = consensus_error(ii)./obj.topology.N;
                if(consensus_error(ii) < threshold)
                    final_value = current_values(:, 1);
                    return
                end
            end
            
            final_value = current_values(:, 1);
            
        end
        
    end
    
end