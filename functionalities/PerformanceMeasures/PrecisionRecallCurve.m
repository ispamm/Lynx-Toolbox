% PrecisionRecallCurve - Compute the Precision-Recall curve
%   The precision-recall curve is stored as a XYPlot object
%
% See also: PerformanceMeasure, XYPlotContainer, XYPlot

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef PrecisionRecallCurve < PerformanceMeasure & XYPlotContainer
    
    properties(Constant)
        isComparable = false;
    end
    
    methods
        
        function p = initParameters(obj, p)
        end
        
        function obj = PrecisionRecallCurve()
            obj = obj@PerformanceMeasure();
        end
        
        function prcurve  = compute( ~, true_values, ~, scores )
            true_values(true_values == -1) = 0;
            scores = (scores + 1)./2;
            [prec, tpr] = prec_rec(scores, true_values);
            % Hack for algorithms with no confidence scores
            if(length(prec) == 2 && tpr(2) == 1)
                prec(2) = [];
                tpr(2) = [];
            end
            prcurve = XYPlot(tpr, prec, 'Recall', 'Precision');
        end

    end
    
    methods(Static)
        
        function c = initializeContainer()
            c = XYPlotContainer();
        end
        
        function info = getDescription()
            info = 'Precision-recall curve';
        end
        
        function b = isCompatible(t)
            b = t == Tasks.BC;
        end
        
    end
    
end