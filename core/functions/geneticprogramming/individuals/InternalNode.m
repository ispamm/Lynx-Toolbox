classdef InternalNode < LeafNode
    % INTERNALNODE An abstract class implementing an internal node of the
    % kernel tree
    %
    % LEAFNODE Properties
    %
    %   params - A vector of parameters of the kernel
    %
    %   nArity - 1 for unary operations and 2 for binary operations
    %
    %   leftNode - The left child
    %
    %   rightNode - The right child (empty for unary operators)
    %
    % LEAFNODE Methods
    %
    %   evaluate - Compute the Kernel matrix for a given training (and/or)
    %   test matrix
    %
    %   length - Number of nodes composing the kernel, including the object
    %   itself
    %
    %   depth - Depth of the kernel including the object itself
    %
    %   isTerminal - This is always false
    %
    %   getNthNode - Return the n-th node, where n can range from 1 to the
    %   length of the object, and nodes are counted in a depth-first
    %   fashion
    %
    %   setNthNode - Set the n-th node to a new node, nodes are counted in
    %   a depth-first fashion
    %
    %   prune - Prune nodes that are under a certain maximal depth. The
    %   non-terminal nodes at the maximal depth are replaced by the
    %   right-most terminal node under them.
    %
    %   getParameters - Return the parameters of the kernel, concatenated
    %   in a depth-first search
    %
    %   setParameters - Set the parameters of the kernel
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    properties
        nArity; % Whether the node represents a unitary or binary operation
        leftNode;
        rightNode;
    end
    
    methods
        
        % An internal node must be constructed starting from its
        % descendants
        function obj = InternalNode(leftNode, rightNode)
            obj.leftNode = leftNode;
            if(nargin > 1)
                obj.rightNode = rightNode;
            end
        end
        
        function len = length(obj)
            if(obj.nArity == 1)
                len = 1 + obj.leftNode.length();
            else
                len = 1 + obj.leftNode.length() + obj.rightNode.length();
            end
        end
        
        function d = depth(obj)
            if(obj.nArity == 1)
                d = 1 + obj.leftNode.depth();
            else
                d = 1 + max(obj.leftNode.depth(), obj.rightNode.depth());
            end
        end
        
        function b = isTerminal(~)
            b = false;
        end
        
        % Get the n-th node in a depth-first search strategy
        function nthnode = getNthNode(obj, n)   
            % If n==1, return the current node
            if(n == 1)
               nthnode = obj;
            else
                % Is the node on the left?
               lengthLeftNode = obj.leftNode.length();
               if(lengthLeftNode >= (n-1))
                   nthnode = obj.leftNode.getNthNode(n-1);
               else
                   % Search it on the right
                   n = n - lengthLeftNode;
                   if(obj.nArity > 1)
                        lengthRightNode = obj.rightNode.length();
                        if(lengthRightNode >= (n-1))
                            nthnode = obj.rightNode.getNthNode(n-1);
                        else
                            error('K:OutOfBounds', 'Index out of bounds in searching the node');
                        end
                   else
                       error('K:OutOfBounds', 'Index out of bounds in searching the node');
                   end
               end
            end
        end
        
        function obj = setNthNode(obj, n, newNode)
            % If n==1, set the current node
            if(n == 1)
               obj = newNode;
            else
                % Is the node on the left?
               lengthLeftNode = obj.leftNode.length();
               if(lengthLeftNode >= (n-1))
                   obj.leftNode = obj.leftNode.setNthNode(n-1, newNode);
               else
                   % Search it on the right
                   n = n - lengthLeftNode;
                   if(obj.nArity > 1)
                        lengthRightNode = obj.rightNode.length();
                        if(lengthRightNode >= (n-1))
                            obj.rightNode = obj.rightNode.setNthNode(n-1, newNode);
                        else
                            error('K:OutOfBounds', 'Index out of bounds in searching the node');
                        end
                   else
                       error('K:OutOfBounds', 'Index out of bounds in searching the node');
                   end
               end
            end
        end
        
        % Prune the tree up to a certain depth
        function obj = prune(obj, maxDepth)
            assert(maxDepth > 0, 'Maximum depth has to be > 0');
            if(maxDepth == 1)
                obj = obj.getNthNode(obj.length());
            else
                obj.leftNode = obj.leftNode.prune(maxDepth - 1);
                if(obj.nArity > 1)
                    obj.rightNode = obj.rightNode.prune(maxDepth - 1);
                end
            end
        end
        
        function [params, isInteger, lowerBound, upperBound] = getParameters(obj)
            if(~isempty(obj.params))
                params = struct2array(obj.params); 
                isInteger = false;
                lowerBound = 0;
                upperBound = 1;
            else
                params = [];
                isInteger = [];
                lowerBound = [];
                upperBound = [];
            end
            [paramsLeft, isIntegerLeft, lbleft, ubleft] = obj.leftNode.getParameters();
            if(obj.nArity > 1)
                [paramsRight, isIntegerRight, lbright, ubright] = obj.rightNode.getParameters();
            else
                paramsRight = [];
                isIntegerRight = [];
                lbright = [];
                ubright = [];
            end
            
            params = [params; paramsLeft; paramsRight];
            isInteger = [isInteger; isIntegerLeft; isIntegerRight];
            lowerBound = [lowerBound; lbleft; lbright];
            upperBound = [upperBound; ubleft; ubright];
        end
            
        function [obj, params] = setParameters(obj, params)
           if(~isempty(obj.params))
               tmp = fieldnames(obj.params);
               obj.params.(tmp{1}) = params(1);
               params(1) = [];
           end
           [obj.leftNode, params] = obj.leftNode.setParameters(params);
           if(obj.nArity > 1)
               [obj.rightNode, params] = obj.rightNode.setParameters(params);
           end
        end
        
    end
    
end

