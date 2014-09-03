function download_datasets()
% DOWNLOAD_DATASETS Download additional dataset
%   This function downloads additional datasets from the author's webpage.
%   The process is fully automatic.

url = 'http://ispac.ing.uniroma1.it/scardapane/lynxdatasets/';

clc;

cprintf('*text', '--- The process requires working internet connection, and a few minutes. Continue? (Y/N) ---\n');
result = input('', 's');

if(strcmpi(result, 'y'))

    fprintf('Fetching the list of datasets...\n');
    datasetsFile = urlread(strcat(url, 'Datasets.txt'));
    D = textscan(datasetsFile, '%s%s%s%s');
    
    datasetsDownloaded = 0;
    datasetsFailures = 0;
    
    for ii = 1:length(D{1})
       
        currentTask = Tasks.getById(Tasks.(D{1}{ii}));
        fprintf('Downloading dataset %s (%s), %s %s... ', D{2}{ii}, currentTask.getDescription(), D{3}{ii}, D{4}{ii});
        
        try
            remoteFile = strcat(url, D{1}{ii}, '/', D{2}{ii}, '.zip');
            localDir = fullfile(XmlConfiguration.getRoot(), 'datasets', D{1}{ii});
            unzip(remoteFile, localDir);
            cprintf('comment', 'SUCCESS\n');
            datasetsDownloaded = datasetsDownloaded + 1;
        catch
            cprintf('err', 'FAILURE\n');
            datasetsFailures = datasetsFailures + 1;
        end
        
    end
    
    fprintf('Complete, %i downloaded, %i failures.\n', datasetsDownloaded, datasetsFailures);
    if(datasetsFailures > 0)
        fprintf('Please contact the author for information on the failed datasets\n');
    end

end

end

