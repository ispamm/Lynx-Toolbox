% ConfusionMatrix - Compute the confusion matrix
%   The confusion matrix is stored as a LabeledMatrix object, where rows
%   and column labels corresponds to the possible values of the dataset.
%
% See also: PerformanceMeasure, LabeledMatrixContainer, LabeledMatrix

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef ConfusionMatrix < PerformanceMeasure & LabeledMatrixContainer
    properties(Constant)
        isComparable = false;
    end
    
    methods
        
        function p = initParameters(obj, p)
        end
        
        function obj = ConfusionMatrix()
            obj = obj@PerformanceMeasure();
        end
        
        function cm  = compute( ~, true_values, predictions, ~ )
            cm = LabeledMatrix(confusionmat(true_values, predictions), unique(true_values), unique(true_values));
        end

    end
    
    methods(Static)
        
        function c = initializeContainer()
            c = LabeledMatrixContainer();
        end
        
        function info = getDescription()
            info = 'Confusion matrix';
        end
        
        function b = isCompatible(t)
            b = t == Tasks.BC || t == Tasks.MC;
        end
        
    end
    
end