% CyclicLatticeTopology
    
% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef CyclicLatticeTopology < NetworkTopology
    
    properties
        K;
    end
    
    methods
        function obj = CyclicLatticeTopology(N, K)
            obj = obj@NetworkTopology(N);
            assert(mod(K, 2) == 0, 'Lynx:Runtime:Validation', 'The parameter K for SmallWorldTopology must be even');
            obj.K = K;
        end
        
        function obj = construct(obj)

            for i = 1:obj.N
                for j = 1:(obj.K/2)
                    if(i + j > obj.N)
                        idx = i + j - obj.N;
                    else
                        idx = i + j;
                    end
                    obj.W(i, idx) = 1;
                    obj.W(idx, i) = 1;
                    
                    if(i-j <= 0)
                        idx = i - j + obj.N;
                    else
                        idx = i - j;
                    end
                    obj.W(i, idx) = 1;
                    obj.W(idx, i) = 1;
                end
            end
            
        end
        
        function s = getDescription(obj)
            s = sprintf('Cyclic lattice with %i neighbors', obj.K);
        end
    end
    
end

