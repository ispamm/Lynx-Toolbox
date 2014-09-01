% ExpOperator - Returns a new kernel knew = exp(k)

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef ExpOperator < InternalNode
    
    methods
        
        function obj = ExpOperator(leftNode, ~)
            obj = obj@InternalNode(leftNode);
            obj.nArity = 1;
        end
        
        function Omega = evaluateTraining(obj, X)
            Omega = exp(obj.leftNode.evaluate(X));
        end
        
        function Omega = evaluateTesting(obj, X, Xts)
            Omega = exp(obj.leftNode.evaluate(X, Xts));
        end
        
        function str = print(obj)
            str = sprintf('exp{%s}', obj.leftNode.print());
        end
        
        function fcn = getSymbolicFunction(obj, x, y)
            fcn = exp(obj.leftNode.getSymbolicFunction(x, y));
        end
        
    end
    
    
end

