% MisclassificationError - Misclassification error
%   Compute the misclassification error, defined as the percentage of
%   inexact labels

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef MisclassificationError < LossFunction & PercentageContainer
    
    methods
        
        function p = initParameters(obj, p)
        end
        
        function perf  = compute( obj, true_values, predictions, ~ )
            perf = 1 - sum(true_values == predictions)/length(predictions);
        end
        
    end
    
    methods(Static)
        
        function c = initializeContainer()
            c = PercentageContainer();
        end
        
        function info = getDescription()
            info = 'Misclassification rate';
        end
        
        function b = isCompatible(t)
            b = t == Tasks.BC || t == Tasks.MC;
        end
        
    end
end