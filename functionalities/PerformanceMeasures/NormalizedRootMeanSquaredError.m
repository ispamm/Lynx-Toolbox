% NormalizedRootMeanSquaredError - Normalized Root Mean-Squared Error
%   This is the normalized square root of the mean-squared error (MSE). It
%   this is similar to the root MSE, but the errors are divided by the
%   variance of the outputs.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef NormalizedRootMeanSquaredError < LossFunction & NumericalContainer
    
    methods
        
        function p = initParameters(obj, p)
        end
        
        function err  = compute( obj, true_values, predictions, ~ )
            err = sum((true_values - predictions).^2)/length(predictions);
            if(var(true_values) ~= 0)
                err = sqrt(err/var(true_values));
            else
                err = sqrt(err);
            end
        end
        
    end
    
    methods(Static)
        
        function info = getDescription()
            info = 'Normalized Root Mean-squared error';
        end
        
        function b = isCompatible(t)
            b = t == Tasks.BC || t == Tasks.MC || Tasks.R;
        end
        
    end
end



