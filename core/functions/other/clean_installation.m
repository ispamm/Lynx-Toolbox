
% clean_installation - Clean the installation

clc; 

warning('This will restore the original state of the toolbox, deleting all results, saved models and installed libraries. Do you want to continue? (Y/N)');
result = input('', 's');
if(strcmpi(result, 'Y'))

    clear all;
    root = XmlConfiguration.readConfigValue('root_folder');
    
    % Delete XML configuration file
    fprintf('Removing configuration file...\n');
    delete(fullfile(root, 'config.xml'));

    % Add the folders of the toolbox to the global path
    fprintf('Removing toolbox from path...\n');
    warning('off', 'MATLAB:rmpath:DirNotFound');
    rmpath(genpath(root));
    warning('on', 'MATLAB:rmpath:DirNotFound');

    % Removed directories
    fprintf('Removing temporary folders...\n');
    directories = {'tmp', 'results', 'lib', 'models', 'doc'};
    for i=1:length(directories)
        if(exist(directories{i}, 'dir'))
            rmdir(fullfile(root, directories{i}), 's');
        end
    end

    fprintf('Cleaning process complete\n');
    
    
else
    fprintf('Cleaning process aborted by user\n');
end