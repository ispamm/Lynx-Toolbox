classdef PerfMse < PerformanceMeasure
    %PerfMse Compute performance using the standard mean-squared error.
    %
    %   The MSE is defined as err = sqrt(errors/N).
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    methods(Static)

        function err  = compute( true_values, predictions )
            err = sum((true_values - predictions).^2)/length(predictions);
        end
        
        function info = getInfo()
            info = 'Mean squared error';
        end
    end
end



