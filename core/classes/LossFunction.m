% LossFunction - A numerical performance measure
%   A LossFunction is a numerical performance measure representing the
%   "loss" of an algorithm over a dataset. A lower loss value is better
%   than an higher loss value.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef LossFunction < PerformanceMeasure
    
    properties(Constant)
        isComparable = true;
    end
    
    methods(Abstract)
        perf = compute(obj, true_labels, predictions, scores);
    end
    
    methods
        function b = isBetterThan(obj, perf)
            b = obj.getFinalizedValue() < perf.getFinalizedValue();
        end
    end
    
    methods(Static)
        
        function c = initializeContainer()
            c = NumericalContainer();
        end
        
    end
    
    methods (Abstract,Static)
        info = getDescription();
    end
    
end

