% SmallWorldTopology - Small world topology
%   This is a small world graph
    
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
            assert(isinrange(beta), 'Lynx:Runtime:Validation', 'The beta parameter of SmallWorldNetwork must be in [0, 1]');
            obj.beta = beta;
        end
        
        function obj = construct(obj)
            obj = obj.construct@CyclicLatticeNetwork();
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

