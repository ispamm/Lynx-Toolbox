% ScaleFreeNetwork
    
% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef ScaleFreeTopology < NetworkTopology
    
    properties
        m0;
        m;
    end
    
    methods
        function obj = ScaleFreeTopology(N, m0, m)
            obj = obj@NetworkTopology(N);
            obj.m0 = m0;
            obj.m = m;
        end
        
        function obj = construct(obj)
            
            initW = RandomTopology(obj.m0, 0.25);
            initW = initW.initialize();
            initW = initW.W;
            
            for i = 1:obj.N - obj.m0
                
                deg = sum(initW, 2);
                deg = deg./sum(deg);
                x = rand(obj.m0 + i - 1, 1) - deg;
                [~, sortingIndices] = sort(x,'descend');
                maxValueIndices = sortingIndices(1:obj.m);
                
                newNeighbors = zeros(obj.m0 + i - 1, 1);
                newNeighbors(maxValueIndices) = 1;
                
                initW = [initW newNeighbors; newNeighbors' 0];
                
            end
            
            obj.W = initW;
            
        end
        
        function s = getDescription(obj)
            s = sprintf('Scale free network');
        end
    end
    
end

