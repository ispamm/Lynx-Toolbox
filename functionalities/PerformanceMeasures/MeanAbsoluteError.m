% MeanAbsoluteError - Mean Absolute Error
%   Compute the Mean Absolute Error, defined as the average of the
%   absolute value of the errros

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef MeanAbsoluteError < LossFunction & NumericalContainer
    
    methods
        
        function p = initParameters(obj, p)
        end
        
        function perf  = compute(~, true_values, predictions, ~ )
            perf = sum(abs(true_values - predictions))/length(predictions);
        end
        
    end
    
    methods(Static)
        
        function info = getDescription()
            info = 'Mean absolute error';
        end
        
        function b = isCompatible(t)
            b = t == Tasks.BC || t == Tasks.MC || Tasks.R;
        end
        
    end
    
end

