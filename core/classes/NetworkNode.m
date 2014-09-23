% NetworkNode - Utility class for nodes in a network
%   A network node has access to the topology of the network. For example,
%   it can gather the indices of node i as:
%
%   obj.topology.getNeighbors(i);
%
%   Additionally, this class provides utility methods for running a
%   consensus algorithm on the network.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef NetworkNode
    
    properties
        topology; % The topology of the network
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
            % Execute consensus algorithm (parallel). This must be run
            % inside an SPMD block. Parameters are:
            %
            %   - INITIAL_VALUE: initial value of the lab (vector of
            %   numbers)
            %   - STEPS - maximum number of consensus iterations
            %   - THRESHOLD - currently unused
            %
            % Output values are the final value after the consensus
            % strategy, and the evolution of disagreement during the
            % consensus steps.
            
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
            % This is a serial implementation of the consensus strategy.
            % Parameters are:
            %
            %   - INITIAL_VALUES: matrix of initial values. For consensus
            %   of d-dimensional vectors, this is a dxN matrix, where N is
            %   the total number of agents. For consensus on RxC matrices,
            %   this a RxCxN tensor.
            %
            %   - STEPS: maximum number of iterations
            %
            %   - THRESHOLD: threshold for the disagreement norm. When this
            %   is the lower than the threshold on all nodes, consensus is
            %   ended.
            %
            % Output values are the computed average, and the average
            % evolution of the disagreement on the nodes.
            
                
            current_values = initial_values;
            consensus_error = zeros(steps, 1);
            is_matrix = ndims(initial_values) == 3;
            
            for ii = 1:steps
                new_values = current_values;
                for jj = 1:obj.topology.N
                    idx = obj.getNeighbors(jj);
                    if(is_matrix)
                        new_values(:, :, jj) = (current_values(:, :, jj) + sum(current_values(:, :, idx), 3))/(length(idx) + 1);
                        consensus_error(ii) = consensus_error(ii) + norm(current_values(:, :, jj) - new_values(:, :, jj), 'fro');
                    else
                        new_values(:, jj) = (current_values(:, jj) + sum(current_values(:, idx), 2))/(length(idx) + 1);
                        consensus_error(ii) = consensus_error(ii) + norm(current_values(:, jj) - new_values(:, jj));
                    end
                end
                
                consensus_error(ii) = consensus_error(ii)./obj.topology.N;
                current_values = new_values;
                
                if(consensus_error(ii) < threshold)
                    break;
                end
            end
            
            if(is_matrix)
                final_value = current_values(:, :, 1);
            else
                final_value = current_values(:, 1);
            end
            
            
        end
        
    end
    
end