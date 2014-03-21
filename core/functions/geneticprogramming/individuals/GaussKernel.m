classdef GaussKernel < LeafNode
    %GAUSSKERNEL A Gaussian kernel k(x,y) = exp(-a*||x-y||^2)
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    methods
        
        % The Gaussian kernel has only a single parameter
        function obj = GaussKernel(a)
           obj.params.a = a;
        end
        
        function Omega = evaluateTraining(obj, X)
           Omega = exp(-obj.params.a*pdist2(X,X,'euclidean').^2);
        end
        
        function Omega = evaluateTesting(obj, X, Xts)
           Omega = exp(-obj.params.a*pdist2(Xts,X,'euclidean').^2);
        end
        
        % Return a string describing the kernel
        function str = print(obj)
            str = sprintf('exp(-%.5f*||x-y||^2)', obj.params.a);
        end
        
        function [params, isInteger, lowerBound, upperBound] = getParameters(obj)
            params = obj.params.a;
            isInteger = false;
            lowerBound = 10^(-5);
            upperBound = 1;
        end
        
        function [obj, params] = setParameters(obj, params)
            obj.params.a = params(1);
            params(1) = [];
        end
        
        function fcn = getSymbolicFunction(obj, x, y)
            fcn = exp(-obj.params.a*(x*y').^2);
        end
        
    end
    
end

