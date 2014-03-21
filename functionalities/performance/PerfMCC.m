classdef PerfMCC < PerformanceMeasure
    % PERFMCC Inverse of the Matthew Correlation Coefficient.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    
    methods(Static)

        function err  = compute( true_values, predictions )
            C = confusionmat(true_values,predictions);
            TP = C(1,1);
            FP = C(1,2);
            FN = C(2,1);
            TN = C(2,2);
            
            err = - (TP*TN-FP*FN)/sqrt((TP+FP)*(TP+FN)*(TN+FP)*(TN+FN));
        end
        
        function info = getInfo()
            info = 'Inverse of the Matthew Correlation Coefficient';
        end
    end
end