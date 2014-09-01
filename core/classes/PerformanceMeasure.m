% PerformanceMeasure - Compute a performance of a learning algorithm
%   A PerformanceMeasure object describes the performance of a learning
%   algorithm on a given dataset. If p is a performance measure, its
%   main method is given by:
%
%   o = p.compute(real_labels, predicted_labels, confidence_values);
%
%   A performance measure can be a loss term, a matrix (e.g. a
%   confusion matrix), an x-y plot, or something more complex. If it
%   represents a comparable value, it must implement the method
%   isBetterThan to compare two different outputs.
%
%   Each PerformanceMeasure has an associated default container which
%   can be retrieved using the initializeContainer method.
%
% See also: Parameterized

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef PerformanceMeasure < Parameterized & ValueContainer
    
    properties(Abstract,Constant)
        % Whether two objects of this class are comparable
        isComparable;
    end
    
    methods(Abstract)
        % Compute the performance measure
        perf = compute(obj, true_labels, predictions, scores);
        
    end
    
    methods(Abstract,Static)
        % Check that the performance is compatible with the task
        b = isCompatible(t);
    end
    
    methods
        function obj = computeAndStore(obj, true_labels, predictions, scores)
            obj = obj.store(obj.compute(true_labels, predictions, scores));
        end
        
        % Compare two performance values
        function b = isBetterThan(~, ~)
            error('Lynx:Logical:PerformanceError', 'The isBetterThan method is not instantiated');
        end
    end

    
end

