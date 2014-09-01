% RocCurve - Compute the ROC curve
%   The roc curve is stored as a XYPlot object
%
% See also: PerformanceMeasure, XYPlotContainer, XYPlot

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef RocCurve < PerformanceMeasure & XYPlotContainer
    
    properties(Constant)
        isComparable = false;
    end
    
    methods
        
        function p = initParameters(obj, p)
        end
        
        function obj = RocCurve()
            obj = obj@PerformanceMeasure();
        end
        
        function roccurve  = compute( ~, true_values, ~, scores )
            true_values(true_values == -1) = 0;
            scores = (scores + 1)./2;
            [tpr, fpr, t] = roc(true_values', scores');
            roccurve = XYPlot(fpr, tpr, 'False positive rate', 'True positive rate');
        end

    end
    
    methods(Static)
        
        function c = initializeContainer()
            c = XYPlotContainer();
        end
        
        function info = getDescription()
            info = 'ROC curve';
        end
        
        function b = isCompatible(t)
            b = t == Tasks.BC;
        end
        
    end
    
end