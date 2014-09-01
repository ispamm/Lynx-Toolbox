% LeafNode - An abstract class implementing a leaf of a kernel tree
%
% LeafNode Properties
%
%   params - A vector of parameters of the kernel
%
% LeafNode Methods
%
%   evaluate - Compute the Kernel matrix for a given training (and/or)
%   test matrix
%
%   length - This is always 1
%
%   depth - This is always 1
%
%   isTerminal - This is always true
%
%   getNthNode - Return the object itself is n=1, otherwise throws an
%   error
%
%   setNthNode - Set itself to a new object if N=1, otherwise throws an
%   error
%
%   prune - Throws an error except if the maximum depth is 0
%
%   getParameters - Return the parameters of the kernel
%
%   setParameters - Set the parameters of the kernel

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef LeafNode
    
    properties
        params;     % The parameters of the kernel
    end
    
    methods(Abstract)
        
        % Returns the Gram matrix starting from a kernel
        Omega = evaluateTraining(obj, X);
        Omega = evaluateTesting(obj, X, Xts);
        
        % Return a string describing the kernel
        str = print(obj);
        
        % Set and get parameters
        [params, isInteger, lowerBound, upperBound] = getParameters(obj);
        [obj, params] = setParameters(obj, params);
        
        fcn = getSymbolicFunction(obj, x, y);
        
    end
    
    methods
        
        function Omega = evaluate(obj, X, Xts)
            if(nargin < 3 || isempty(Xts))
                Omega = obj.evaluateTraining(X);
            else
                Omega = obj.evaluateTesting(X,Xts);
            end
        end
        
        % The length of a leaf node is 1
        function len = length(~)
            len = 1;
        end
        
        % The depth of a leaf node is 1
        function d = depth(~)
            d = 1;
        end
        
        % This is a terminal node (useful for recursive functions)
        function b = isTerminal(~)
            b = true;
        end
        
        % Needed for recursive functions
        function nthnode = getNthNode(obj, n)
            if(n ~= 1)
                error('K:OutOfBounds', 'Index out of bounds in searching a node');
            end
            nthnode = obj;
        end
        function obj = setNthNode(obj, n, newNode)
            if(n ~= 1)
                error('K:OutOfBounds', 'Index out of bounds in searching a node');
            end
            obj = newNode;
        end
        
        function obj = prune(obj, max_depth)
            assert(max_depth > 0, 'Maximum depth has to be > 0');
        end
        
    end
    
end

