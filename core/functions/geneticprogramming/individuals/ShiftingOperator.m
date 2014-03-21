classdef ShiftingOperator < InternalNode
    %SHIFTINGOPERATOR Shift a given kernel by a constant factor.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
   
    methods
        
        function obj = ShiftingOperator(leftNode, ~, shiftFactor)
            obj = obj@InternalNode(leftNode);
            obj.params.shiftFactor = shiftFactor;
            obj.nArity = 1;
        end
        
        function Omega = evaluateTraining(obj, X)
            Omega = obj.leftNode.evaluate(X) + obj.params.shiftFactor;
        end
        
        function Omega = evaluateTesting(obj, X, Xts)
            Omega = obj.leftNode.evaluate(X, Xts)  + obj.params.shiftFactor;
        end
        
        function str = print(obj)
            str = sprintf('[%s + %.2f]', obj.leftNode.print(), obj.params.shiftFactor);
        end
        
        function fcn = getSymbolicFunction(obj, x, y)
            fcn = obj.leftNode.getSymbolicFunction(x, y) + obj.params.shiftFactor;
        end
        
    end
    
    
end

