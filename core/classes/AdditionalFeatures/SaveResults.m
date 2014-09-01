% SaveResults - Save results of the simulation
%   The results are saved in the 'results' folder, and they are
%   constituted by: (i) the configuration file, (ii) a verbatim file
%   with the transcript of the simulation, (iii) a .mat file with the
%   full workspace.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef SaveResults < AdditionalFeature
    
    properties
        fold;           % Folder for saving the results
        verbatimFile;   % Verbatime file
    end
    
    methods
        function obj = SaveResults(f)
            obj.fold = f;
        end
        
        function executeBeforeInitialization(obj)
            % verbatimFile is the file where all the log of the console is written.
            % It is initially placed in the tmp folder, and eventually moved to the
            % result folder. The actual logging is performed with the diary
            % function of Matlab.
            fprintf('Activating logging...\n');
            currentTime = datestr(now, 'yyyymmdd_HHMM');
            obj.verbatimFile = strcat('verbatim_', currentTime, '.txt');
            diary(fullfile(XmlConfiguration.getRoot(), 'tmp', obj.verbatimFile));
            diary('on');
        end
        
        function executeAfterFinalization(obj)
                % Generate folder
                resultFolder = fullfile(XmlConfiguration.getRoot(), 'results', obj.fold);
                mkdir(resultFolder);
                
                fprintf('Saving workspace...\n');
                resultsFile = fullfile(resultFolder, 'results.mat');
                save(resultsFile);
                    
                % Close the diary
                diary('off');
                    
                s = Simulation.getInstance();
                movefile(fullfile(XmlConfiguration.getRoot(), 'tmp', obj.verbatimFile), resultFolder);
                copyfile(s.configFile, resultFolder);
        end
       
        function executeOnError(obj)
            % Close the diary
            diary('off');
            warning('off', 'MATLAB:DELETE:FileNotFound');
            delete(fullfile(XmlConfiguration.getRoot(), 'tmp', obj.verbatimFile));
            warning('on', 'MATLAB:DELETE:FileNotFound');
        end
        
   
        function s = getDescription(obj)
            s = sprintf('Save results of the simulation in folder %s', obj.fold)';
        end
    end
    
end

