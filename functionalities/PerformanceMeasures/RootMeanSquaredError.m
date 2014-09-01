% RootMeanSquaredError - Root Mean-Squared Error
%   This is the square root of the mean-squared error (MSE). Differently
%   from the standard MSE, this has the same unit measure as the original
%   input values.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef RootMeanSquaredError < LossFunction & NumericalContainer
    
    methods
        
        function p = initParameters(obj, p)
        end
        
        function err  = compute( obj, true_values, predictions, ~ )
            p = MeanSquaredError();
            err = sqrt(p.compute(true_values, predictions, []));
        end
        
    end
    
    methods(Static)
        
        function info = getDescription()
            info = 'Root Mean-squared error';
        end
        
        function b = isCompatible(t)
            b = t == Tasks.BC || t == Tasks.MC || Tasks.R;
        end
        
    end
end



