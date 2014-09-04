% NetworkTopology - Abstract class for creating network topologies
%   A network topology is a graph detailing how a set of nodes is
%   interconnected. Given an implementation T, we can use it as follows.
%   First, construct the topology:
%
%   o = T(N, varargin);
%
%   Secondly, you need to initialize it:
%
%   o = o.initialize();
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
%   method construct() to create the topology.
%
%   Note that network topologies are required to be undirected and
%   connected.

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
        function obj = NetworkTopology(N)
            % Construct the NetworkTopology object
            obj.N = N;
            obj.W = zeros(N, N);
        end
        
        function visualize(obj, t)
            % Plot the graph
            % The optional value is the title of the plot
            
            if(nargin < 2)
                t = 'Graph viewer';
            end
            % Plot the graph (need the Bioinformatics toolbox)
            if(exist('biograph', 'file') == 2)
                % Very complicated hack to set the title and shift the
                % figures
                b = biograph(sparse(triu(obj.W)));
                b.showArrows = 'off';
                view(b);
                set(0, 'ShowHiddenHandles', 'on');
                bgfig = gcf;
                c = get(bgfig, 'Children');
                copyobj(c(1), figure);
                figshift;
                set(gcf, 'Name', t);
                close(bgfig);
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
        
        function obj = initialize(obj)
            % Initialize the topology
            obj = obj.construct();
            counter = 1;
            while(~(obj.isConnected()))
                if(counter > 10)
                    error('Lynx:Initialization:Stochastic', 'Failed to initialize a connected network topology');
                end
                obj = obj.construct();
                counter = counter + 1;
            end
        end
        
        function b = isConnected(obj)
            % Check if the graph is connected
            S = graphconncomp(sparse(obj.W), 'Weak', true, 'Directed', false);
            b = S == 1;
        end
    end
    
    methods(Abstract)
        % Construct a possible topology
        obj = construct(obj);
        
        % Get description
        s = getDescription(obj);
    end
    
   
end

