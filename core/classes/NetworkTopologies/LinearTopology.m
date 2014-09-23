% LinearTopology - Linear topology
%   A linear network of N agents is an ordered collection 1, ..., N of
%   nodes, each one connected to its K direct successors (except the last
%   N-K+1 nodes, connected to the remaining).
%   
%   Initialize the topology with the K parameter:
%
%       t = LinearTopology(N, K);
    
% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef LinearTopology < NetworkTopology
    
    properties
        K;
    end
    
    methods
        function obj = LinearTopology(N, K)
            obj = obj@NetworkTopology(N);
            obj.K = K;
        end
        
        function obj = construct(obj)
            for i = 1:obj.N
                for j = 1:(obj.K)
                    if(i + j > obj.N)
                        continue;
                    end
                    
                    obj.W(i, i+j) = 1;
                    obj.W(i+j, i) = 1;
                end
            end
        end
        
        function s = getDescription(obj)
            s = sprintf('Linear topology');
        end
    end
    
end

