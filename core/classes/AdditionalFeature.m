% AdditionalFeature - Additional feature for the simulation
%   An AdditionalFeature has several methods which are executed at
%   fixed points during the simulation, in particular:
%
%   executeBeforeInitialization - executed after the configuration file
%   is read, but before further actions
%
%   executeAfterInitialization - executed after the initialization
%   phase
%
%   executeBeforeEachExperiment - executed before every experiment, it
%   can change the characteristics of the current algorithm and dataset
%
%   executeAfterEachExperiment - executed after every experiment
%
%   executeBeforeFinalization - executed after the results are printed
%   on output, but before the final actions of the simulation
%
%   executeAfterFinalization - executed after everything is completed
%
%   executeOnError - executed in case of an error
%
%   All these methods are empty be default. An AdditionalFeature can
%   override just one, or more, of the methods depending on the needed
%   behavior.
%
%   For the simplest example of implementation, see SetSeedPRNG.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef AdditionalFeature < handle
    
    methods
        
        function executeBeforeInitialization(obj)
            % Execute before initialization
        end
        
        function executeAfterInitialization(obj)
            % Execute before the experiments are started
        end

        function executeBeforeFinalization(obj)
            % Execute before finalizing the simulation
        end
        
        function executeAfterFinalization(obj)
            % Execute before exiting
        end
        
        function [a, d] = executeBeforeEachExperiment(obj, a, d)
            % Execute before each experiment
            % This takes in input the current algorithm and dataset
        end
        
        function [a, d] = executeAfterEachExperiment(obj, a, d)
            % Execute after each experiment
        end
        
        function executeOnError(obj)
            % Execute in case there is an error
        end
    end
    
    methods(Abstract)
        % Get a description of the feature
        s = getDescription(obj);
    end
    
end


