% INSTALL Installation script for the toolbox. This adds all the folders to
% the Matlab search path, and searches for the presence of any required
% external libray. If a library is not present, it allows to automatically
% download it from the web and install it.

clc;

% Ensure a supported Matlab version
if verLessThan('matlab', '7.12')
    error('This Matlab version is not supported. Please upgrade to version 7.12 or higher.');
end

% Ensure we are in the root folder
if(~exist(fullfile(pwd, 'install.m'), 'file') == 2)
    error('The installation script must be run from the root folder of the toolbox');
end

% Create the required empty directories
directoryCreated = false;
directories = {'tmp', 'results', 'lib', 'models'};
for i=1:length(directories)
    if(~exist(directories{i}, 'dir'))
        if(~directoryCreated)
            fprintf('Creating required folders...\n');
            directoryCreated = true;
        end
        mkdir(directories{i});
    end
end

% Add the folders of the toolbox to the global path
fprintf('Adding toolbox to path...\n');
folders = {'configs', 'core', 'functionalities', 'help', 'lib', 'scripts', 'tests', 'tmp'};
addpath(pwd);
for n = 1:length(folders)
    addpath(genpath(fullfile(pwd, folders{n})));
end

% Generate XML configuration file
if(~XmlConfiguration.checkForConfigurationFile(pwd))
    fprintf('Generating configuration file...\n');
    XmlConfiguration.createXmlConfiguration(pwd);
elseif(~strcmp(pwd, fullfile(XmlConfiguration.getRoot())))
        fprintf('Updating installation folder...\n');
        XmlConfiguration.setConfigValue('root_folder', pwd, pwd);
else
    fprintf('The configuration file was not changed\n');
end

% Eventually save the path
cprintf('*text', '--- Do you want to save the path? (Y/N) ---\n');
result = input('', 's');

if(strcmpi(result, 'Y'))
    fprintf('Saving path...\n');
    savepath;
else
    warning('You will need to run again the installation process after rebooting Matlab');
end

fprintf('Installation complete\n\n');

fprintf('A few useful commands:\n\n');
fprintf('\t--> To run a simulation: ''run_simulation''\n');
fprintf('\t--> To download other datasets: ''download_datasets''\n');
fprintf('\t--> To generate HTML documentation: ''generate_documentation''\n');
fprintf('\t--> To generate HTML reports: ''info_datasets'', ''info_models'', ''info_wrappers'', ''info_preprocessors''\n');
fprintf('\t--> To run the test suite: ''run_test_suite''\n');
fprintf('\t--> To clean the installation: ''clean_installation''\n\n');
clear all;