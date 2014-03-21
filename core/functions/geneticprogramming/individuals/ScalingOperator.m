classdef ScalingOperator < InternalNode
    %SCALINGOPERATOR Scale a given kernel by a constant factor.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
   
    methods
        
        function obj = ScalingOperator(leftNode, ~, scaleFactor)
            obj = obj@InternalNode(leftNode);
            obj.params.scaleFactor = scaleFactor;
            obj.nArity = 1;
        end
        
        function Omega = evaluateTraining(obj, X)
            Omega = obj.params.scaleFactor.*obj.leftNode.evaluate(X);
        end
        
        function Omega = evaluateTesting(obj, X, Xts)
            Omega = obj.params.scaleFactor.*obj.leftNode.evaluate(X, Xts);
        end
        
        function str = print(obj)
            str = sprintf('%.2f*[%s]', obj.params.scaleFactor, obj.leftNode.print());
        end
        
        function fcn = getSymbolicFunction(obj, x, y)
            fcn = obj.params.scaleFactor.*obj.leftNode.getSymbolicFunction(x, y);
        end
        
    end
    
    
end

