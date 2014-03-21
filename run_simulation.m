
% RUN_SIMULATION This script runs sequentially all the steps of the
% simulation.
%
% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.

% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

clear all; close all; clc;

% Counter for time
t = clock;

% Initialize the simulation
s = SimulationRunner();

try
    
    % Cleaning function
    finishup = onCleanup(@()(s.finalizeSimulation()));
    
    % Initialize structures with desired configuration
    s = s.init();
    
    % Perform all the experiments
    s = s.performExperiments();
    
    % Print errors and training times
    s = s.formatOutput();
    
    % Perform the statistical test, if possible
    s = s.statisticalTesting();
    
    % Execute any additional output script
    s = s.executeOutputScripts();
    
    % Compute elapsed time
    e = etime(clock, t);
    fprintf('Total elapsed time: %g sec.\n', e);
    
    % Save the results if requested
    s = s.saveResults();
    
    % Clean up the simulation
    s = s.finalizeSimulation();
    
catch err
    
    % If an error is found, show the error message and finalize the
    % simulation
    cprintf('err', 'An error was detected: %s\n', err.message);
    fprintf('Cleaning up...\n');
    s = s.finalizeSimulation();
    
end