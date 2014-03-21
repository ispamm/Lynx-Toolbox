classdef HyperbolicKernel < LeafNode
    %HYPERBOLICKERNEL An hyperbolic kernel k(x,y) = tanh(a*<x,y> + b)
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    methods
        
        % The hyperbolic kernel has scaling and shifting coefficients
        function obj = HyperbolicKernel(a,b)
           obj.params.a = a;
           obj.params.b = b;
        end
        
        function Omega = evaluateTraining(obj, X)
           dotProduct = X*X';
           Omega = tanh(obj.params.a*dotProduct + obj.params.b);
        end
        
        function Omega = evaluateTesting(obj, X, Xts)
           dotProduct = Xts*X';
           Omega = tanh(obj.params.a*dotProduct + obj.params.b);
        end
        
        % Return a string describing the kernel
        function str = print(obj)
            str = sprintf('tanh(%.5f*<x,y>+%.1f)', obj.params.a, obj.params.b);
        end
        
        function [params, isInteger, lowerBound, upperBound] = getParameters(obj)
            params = [obj.params.a; obj.params.b];
            isInteger = [false; false];
            lowerBound = [0; 0.1];
            upperBound = [1; 10];
        end
        
        function [obj, params] = setParameters(obj, params)
            obj.params.a = params(1);
            obj.params.b = params(2);
            params(1:2) = [];
        end
        
        function fcn = getSymbolicFunction(obj, x, y)
            dotProduct = x*y';
            fcn = tanh(obj.params.a*dotProduct + obj.params.b);
        end
    end
    
end

