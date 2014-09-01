% ExecuteOutputScripts - Execute custom output scripts
%   The scripts are contained in the 'scripts' folder, and they are
%   executed at the end of the simulation.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef ExecuteOutputScripts < AdditionalFeature
    
    properties
        scripts; % Cell array of scripts URLs
    end
    
    methods
        function obj = ExecuteOutputScripts(varargin)
            % Each input is a script
            obj.scripts = varargin;
        end
        
        function executeBeforeFinalization(obj)
            if(~isempty(obj.scripts))
                
                fprintf('--------------------------------------------------\n');
                fprintf('--- USER-DEFINED OUTPUT --------------------------\n');
                fprintf('--------------------------------------------------\n');
                
                for i=1:length(obj.scripts)
                    eval(obj.scripts{i});
                end
                
            end
        end
        
        function s = getDescription(obj)
            s = sprintf('Execute %i custom output scripts', length(obj.scripts));
        end
    end
    
end

