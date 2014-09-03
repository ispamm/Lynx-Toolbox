% NetworkTopology - Abstract class for creating network topologies
%   A network topology is a graph detailing how a set of nodes is
%   interconnected. Given an implementation T, we can use it as follows.
%   First, initialize it with the number of nodes and any additional
%   parameter:
%
%   o = T(N, varargin);
%
%   Then, access the list of neighbors of node i as:
%
%   idx = T.getNeighbors(i);
%
%   Get a particular edge value between nodes i and j as:
%
%   v = T.getEdgeValue(i, j);
%
%   Finally, plot the topology as:
%
%   T.visualize();
%
%   Any class implementing NetworkTopology must implement the internal
%   method initialize(varargin) to create the topology.
%
%   We assume that the topology is undirected.
    
% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef NetworkTopology
    
    properties
        N; % Number of nodes
        W; % Weight matrix
    end
    
    methods
        function obj = NetworkTopology(N, varargin)
            % Construct the NetworkTopology object
            obj.N = N;
            obj.W = sparse(zeros(N, N));
            % We try 10 times to initialize it
            obj = obj.initialize(varargin{:});
            counter = 1;
            while(~(obj.isConnected()))
                if(counter > 10)
                    error('Lynx:Initialization:Stochastic', 'Failed to initialize a connected network topology');
                end
                obj = obj.initialize(varargin{:});
                counter = counter + 1;
            end
        end
        
        function visualize(obj)
            % Plot the graph (need the Bioinformatics toolbox)
            if(exist('biograph', 'file') == 2)
                view(biograph(triu(obj.W), [], 'ShowArrows', 'off'));
            end
        end
        
        function idx = getNeighbors(obj, i)
            % Get neighbors indexes of i-th node
            idx = find(obj.W(i, :) ~= 0);
        end
        
        function v = getEdgeValue(obj, i, j)
            % Get edge value between nodes i and j
            v = full(obj.W(i, j));
        end
        
        function b = isConnected(obj)
            % Check if the graph is connected
            S = graphconncomp(obj.W, 'Weak', true, 'Directed', false);
            b = S == 1;
        end
    end
    
    methods(Abstract)
        % Initialize the topology
        obj = initialize(obj, varargin);
        
        % Get description
        s = getDescription(obj);
    end
    
   
end

