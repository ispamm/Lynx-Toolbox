% SmallWorldTopology - Small world topology
%   This is a small world network topology, i.e., a graph with a very low
%   diameter despite a relatively low mean degree of the nodes. This is
%   constructed using the so-called Watts-Strogatz mechanism:
%
%       1) A cyclic lattice is constructed, with K/2 neighbors for each
%       node.
%       2) Every connection is randomly rewired with probability 'beta'.
%
%   Initialize it with the K and beta parameters:
%
%       t = SmallWorldTopology(N, K, beta);
    
% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef SmallWorldTopology < CyclicLatticeTopology
    
    properties
        beta;
    end
    
    methods
        function obj = SmallWorldTopology(N, K, beta)
            obj = obj@CyclicLatticeTopology(N, K);
            assert(isinrange(beta), 'Lynx:Runtime:Validation', 'The beta parameter of SmallWorldTopology must be in [0, 1]');
            obj.beta = beta;
        end
        
        function obj = construct(obj)
            obj = obj.construct@CyclicLatticeTopology();
            for i = 1:obj.N
                neighbors = obj.getNeighbors(i);
                dice = rand(length(neighbors), 1) < obj.beta;
                toBeRewired = neighbors(dice);
                for j = 1:length(toBeRewired)
                    newNeighbor = randi(obj.N, 1);
                    obj.W(i, toBeRewired(j)) = 0;
                    obj.W(toBeRewired(j), i) = 0;
                    obj.W(i, newNeighbor) = 1;
                    obj.W(newNeighbor, i) = 1;
                end
            end
            obj.W(logical(eye(obj.N))) = 0;
        end
        
        function s = getDescription(obj)
            s = sprintf('Small world network');
        end
    end
    
end

