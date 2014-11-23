
% RUN_SIMULATION This script runs sequentially all the steps of the
% simulation.
%
% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.

% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

%clear all; close all; clc;

% Counter for time
t = clock;

% Check for installation
if(~(exist('XmlConfiguration','class') == 8) || ~XmlConfiguration.checkForConfigurationFile(XmlConfiguration.getRoot()))
    error('Lynx:Runtime:MissingInstallation', 'You must run the installation script before executing the simulation');
end

% Initialize the simulation
s = Simulation.getInstance();
s.clear();
s = Simulation.getInstance();

try
    
    % Set PRNG
    rng(s.seed_prng);
    
    % Cleaning function
    finishup = onCleanup(@()(s.finalizeSimulation()));
    
    % Initialize structures with desired configuration
    s = s.init();
    
    % Perform all the experiments
    s = s.performExperiments();
    
    % Print errors and training times
    s = s.formatOutput();
    
    % Execute custom features
    for z = 1:length(s.additionalFeatures)
        s.additionalFeatures{z}.executeBeforeFinalization();
    end
    
    % Clean up the simulation
    s = s.finalizeSimulation();
    
    % Execute custom features
    for z = 1:length(s.additionalFeatures)
        s.additionalFeatures{z}.executeAfterFinalization();
    end
    
    % Compute elapsed time
    e = etime(clock, t);
    fprintf('Total elapsed time: %g sec.\n', e);
    
catch err
    
    % If an error is found, show the error message and finalize the
    % simulation
    cprintf('err', 'An error was detected: %s\n', err.message);
    fprintf('Cleaning up...\n');
    s = s.finalizeSimulation();
    
    % Execute custom features
    for z = 1:length(s.additionalFeatures)
        s.additionalFeatures{z}.executeOnError();
    end
    
end