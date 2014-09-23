% RandomTopology - Random graph
%   A random graph G(N, p) is a graph with N nodes, where each edge has
%   probability p of being present (also known as Erd?s–Rényi random
%   graph).
    
% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef RandomTopology < NetworkTopology
    
    properties
        p;
    end
    
    methods
        function obj = RandomTopology(N, p)
            obj = obj@NetworkTopology(N);
            assert(isinrange(p), 'Lynx:Runtime:Validation', 'Probability for RandomTopology must be in [0, 1]');
            obj.p = p;
        end
        
        function obj = construct(obj)
            dice = triu(rand(obj.N, obj.N));
            dice = dice + triu(dice, 1)';
            obj.W(dice < obj.p) = 1;
            obj.W(logical(eye(obj.N))) = 0;
        end
        
        function s = getDescription(obj)
            s = sprintf('Random graph G(%i, %.1f)', obj.N, obj.p);
        end
    end
    
end

