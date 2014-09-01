% MeanSquaredError - Mean-Squared Error
%   Compute the mean-squared error, defined as the average of the
%   square of the errors

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef MeanSquaredError < LossFunction & NumericalContainer
    
    methods
        
        function p = initParameters(obj, p)
        end
        
        function err  = compute( obj, true_values, predictions, ~ )
            err = sum((true_values - predictions).^2)/length(predictions);
        end
        
    end
    
    methods(Static)
        
        function info = getDescription()
            info = 'Mean squared error';
        end
        
        function b = isCompatible(t)
            b = t == Tasks.BC || t == Tasks.MC || Tasks.R;
        end
        
    end
end



