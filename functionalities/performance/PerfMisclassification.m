classdef PerfMisclassification < PerformanceMeasure
    %PerfMisclassification Compute the misclassification error.
    %
    %   The misclassification error is defined as err = 1 - sum(prediction
    %   /= trueClass)/N.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    methods(Static)

        function err  = compute( true_values, predictions )
            err = 1 - sum(true_values == predictions)/length(predictions);   
        end
        
        function info = getInfo()
            info = 'Misclassification error';
        end
    end
end