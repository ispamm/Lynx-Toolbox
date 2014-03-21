classdef Tasks
    % TASKS A list of all the possible supervised learning tasks implemented
    % in the toolbox.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    enumeration
        R,  % Regression
        BC, % Binary Classification
        MC, % Multiclass Classification
        
        PR, % Prediction (transformed to an R task)
        ML  % Multi-label (transformed to multiple BC tasks)
    end
    
    
end