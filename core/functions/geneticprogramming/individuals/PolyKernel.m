% PolyKernel - A polynomial kernel k(x,y) = (<x,y>)^p

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef PolyKernel < LeafNode
    
    methods
        
        % The polynomial kernel has one parameter, its degree
        function obj = PolyKernel(p)
            obj.params.p = p;
        end
        
        function Omega = evaluateTraining(obj, X)
            Omega = (X*X').^obj.params.p;
            
        end
        
        function Omega = evaluateTesting(obj, X, Xts)
            Omega = (Xts*X').^obj.params.p;
        end
        
        % Return a string describing the kernel
        function str = print(obj)
            str = sprintf('(<x,y>)^%d', obj.params.p);
        end
        
        function [params, isInteger, lowerBound, upperBound] = getParameters(obj)
            params = obj.params.p;
            isInteger = true;
            lowerBound = 1;
            upperBound = 15;
        end
        
        function [obj, params] = setParameters(obj, params)
            obj.params.p = params(1);
            params(1) = [];
        end
        
        function fcn = getSymbolicFunction(obj, x, y)
            fcn = (x*y').^obj.params.p;
        end
    end
    
end

