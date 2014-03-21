classdef PerfNrmse < PerformanceMeasure
    %PerfNrmse Compute performance using the normalized root mean-squared
    %error.
    %
    %   The NRMSE is defined as err = sqrt(normalizedSumOfErrors/N), where
    %   normalizedSumOfErrors = sum(errors^2/varianceOfTrueValues).
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    methods(Static)

        function err  = compute( true_values, predictions )
            err = sum((true_values - predictions).^2)/length(predictions);
            if(var(true_values) ~= 0)
                err = sqrt(err/var(true_values));
            else
                err = sqrt(err);
            end
        end
        
        function info = getInfo()
            info = 'Normalized Root Mean squared error';
        end
    end
end



