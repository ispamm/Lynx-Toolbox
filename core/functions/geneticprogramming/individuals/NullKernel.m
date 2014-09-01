% NullKernel - A dummy class, only used to compute distances

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef NullKernel < LeafNode
    
    methods
        
        function Omega = evaluateTraining(~, ~)
            Omega = [];
        end
        
        function Omega = evaluateTesting(~, ~, ~)
            Omega = [];
        end
        
        % Return a string describing the kernel
        function str = print(~)
            str = sprintf('');
        end
        
        function [params, isInteger, lowerBound, upperBound] = getParameters(~)
            params = [];
            isInteger = [];
            lowerBound = [];
            upperBound = [];
        end
        
        function [obj, params] = setParameters(obj, params)
        end
        
        function fcn = getSymbolicFunction(obj, x, y)
            fcn = 0;
        end
    end
    
end

