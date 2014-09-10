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
            
            % Check if we are inside an SPMD block
            if(isempty(getCurrentWorker()))
                error('Lynx:Runtime:Parallel', 'Consensus algorithm must be executed inside an SPMD block');
            end
            
            % Initialize data structures
            current_value = initial_value;
            consensus_error = zeros(steps, 1);
            
            % Get neighbors indexes
            idx = obj.getNeighbors(labindex);
            
            for ii = 1:steps
                
                % Initialize the new value
                new_value = current_value;
                
                % Send data to all neighbors
                labSend(current_value, idx);
                
                for jj = 1:length(idx)
                    
                    % Receive data
                    while(~labProbe(idx(jj)))
                    end
                    neighbor_property = labReceive(idx(jj));
                    new_value = new_value + neighbor_property;
                    
                end
                
                % Compute new value and error
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