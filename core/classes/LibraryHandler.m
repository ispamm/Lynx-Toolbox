% LibraryHandler - Handler for external libraries
%   Provide some utility methods for checking if an external library is
%   installed, and downloading it from the web

classdef LibraryHandler
    
    methods(Static)
        function b = checkForInstalledLibrary(lib_id)
            % Check if an external library is installed
            b = XmlConfiguration.checkForInstalledLibrary(lib_id);
        end
        
        function b = checkAndInstallLibrary(lib_id, lib_name, lib_url, neededFor)
            % Verify if a library is present, and eventually install it
            fprintf('Checking for presence of %s...\n', lib_name);
            b = LibraryHandler.checkForInstalledLibrary(lib_id);
            if(~b)
                result = '';
                while(~strcmpi(result, 'Y') && ~strcmpi(result, 'N'))
                    cprintf('*text', '--- %s not found. Do you want to install it? (Y/N) ---\n(Required for: %s)\n', lib_name, neededFor);
                    fprintf('\n');
                    result = input('', 's');
                end
                if(strcmpi(result, 'Y'))
                    fprintf('Downloading toolbox... (may take some minutes)');
                    fprintf('\n');
                    [~, ~, ext] = fileparts(lib_url);
                    if(strcmp(ext, '.zip'))
                        tmpFile = fullfile(XmlConfiguration.readConfigValue('root_folder'), 'tmp/tmp.zip');
                    elseif(strcmp(ext, '.gz'))
                        tmpFile = fullfile(XmlConfiguration.readConfigValue('root_folder'), 'tmp/tmp.tar.gz');
                    else
                        error('Lynx:FatalError:ToolboxDownloadError', 'Unrecognized extension');
                    end
                    [~, status] = urlwrite(lib_url, tmpFile);
                    if(status)
                        libFolder = fullfile(XmlConfiguration.readConfigValue('root_folder'), 'lib');
                        if(strcmp(ext, '.zip'))
                            filenames = unzip(tmpFile, libFolder);
                        elseif(strcmp(ext, '.gz'))
                            filenames = untar(tmpFile, libFolder);
                        end
                        [fold, ~, ~] = fileparts(filenames{end});
                        fold = fold(length(libFolder)+1:end); % Remove toolbox path
                        fold = regexp(fold, [filesep,filesep,'([^\\]*)','.*'], 'tokens'); % Extract first folder
                        fold = fold{1};
                        delete(tmpFile);
                        XmlConfiguration.addLibrary(lib_id, lib_name, lib_url, fold);
                        fprintf('\n');
                        cprintf('*Comments', 'Installation of %s succesfull\n', lib_name);
                        fprintf('\n');
                        addpath(genpath(fullfile(XmlConfiguration.getRoot(), 'lib')));
                        b = true;
                    else
                        error('Lynx:FatalError:ToolboxDownloadError', 'There was an error in downloading the toolbox');
                    end
                else
                    b = false;
                end
            end
        end
    end
    
end

