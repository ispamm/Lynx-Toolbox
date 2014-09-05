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
        
        function [final_value, consensus_error] = run_consensus(obj, property_func, steps, threshold)
            % Execute consensus algorithm
            
            current_value = property_func();
            consensus_error = zeros(steps, 1);
            for ii = 1:steps
                idx = obj.getNeighbors(labindex);
                new_value = current_value;
                for jj = 1:length(idx)
                    neighbor_property = labSendReceive(idx(jj), idx(jj), current_value);
                    consensus_error(ii) = consensus_error(ii) + norm(current_value - neighbor_property);
                    new_value = new_value + neighbor_property;
                end
                current_value = new_value./(length(idx) + 1);
                consensus_error(ii) = consensus_error(ii) / length(idx);
            end
            final_value = current_value;
        end
    end
    
end

