% FullyConnectedTopology - Fully connected topology
%   A fully connected topology is a network where each node is connected to
%   all the others. This has no parameters except the size of the network.
%   
    
% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef FullyConnectedTopology < NetworkTopology
    
    properties
    end
    
    methods
        function obj = FullyConnectedTopology(N)
            obj = obj@NetworkTopology(N);
        end
        
        function obj = construct(obj)
            obj.W = ones(obj.N, obj.N);
            obj.W(logical(eye(obj.N))) = 0;
        end
        
        function s = getDescription(obj)
            s = sprintf('Fully connected graph with %i nodes', obj.N);
        end
    end
    
end

