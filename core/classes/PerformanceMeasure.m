classdef PerformanceMeasure
    % PerformanceMeasure An abstract class for defining a performance
    % measure.
    %
    % PerformanceMeasure Methods
    %
    %   compute - Return the error value computed over two Nx1 vectors
    %   labels and predictions, where labels are the true values and
    %   predictions are those given in output by a LearningAlgorithm.
    %
    %   info - Return a string describing the performance measure.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    methods(Abstract,Static)
        err = compute(labels, predictions);
        info = getInfo();
    end
    
end

