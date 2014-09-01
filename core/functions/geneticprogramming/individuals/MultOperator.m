% MultOperator - Multiply two kernels

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef MultOperator < InternalNode
    
    methods
        
        function obj = MultOperator(leftNode, rightNode)
            obj = obj@InternalNode(leftNode, rightNode);
            obj.nArity = 2;
        end
        
        function Omega = evaluateTraining(obj, X)
            Omega = obj.leftNode.evaluate(X).*obj.rightNode.evaluate(X);
        end
        
        function Omega = evaluateTesting(obj, X, Xts)
            Omega = obj.leftNode.evaluate(X, Xts).*obj.rightNode.evaluate(X, Xts);
        end
        
        function str = print(obj)
            str = sprintf('[%s * %s]', obj.leftNode.print(), obj.rightNode.print());
        end
        
        function fcn = getSymbolicFunction(obj, x, y)
            fcn = obj.rightNode.getSymbolicFunction(x, y).*obj.leftNode.getSymbolicFunction(x, y);
        end
        
    end
    
    
end

