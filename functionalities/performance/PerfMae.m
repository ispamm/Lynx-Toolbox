classdef PerfMae < PerformanceMeasure
    %PerfMae Compute the mean-absolute error.
    %
    %   The mean-absolute error is defined as err = sum(abs(|trueValue -
    %   prediction|))/N.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    
    methods(Static)
        function err  = compute( true_values, predictions )
            err = sum(abs(true_values - predictions))/length(predictions);
        end
        
        function info = getInfo()
            info = 'Mean absolute error';
        end
    end
end

