function download_datasets()
% DOWNLOAD_DATASETS Download additional dataset
%   This function downloads additional datasets from the author's webpage.
%   The process is fully automatic.

url = 'http://ispac.diet.uniroma1.it/scardapane/lynxdatasets/';

clc;

cprintf('*text', '--- The process requires working internet connection, and a few minutes. Continue? (Y/N) ---\n');
result = input('', 's');

if(strcmpi(result, 'y'))

    fprintf('Fetching the list of datasets...\n');
    datasetsFile = urlread(strcat(url, 'Datasets.txt'));
    D = textscan(datasetsFile, '%s%s%s%s');
    
    % SUCCESS - PRESENT - FAILURES
    downloadResults = zeros(3, 1);
    
    for ii = 1:length(D{1})
       
        currentTask = Tasks.getById(Tasks.(D{1}{ii}));
        fprintf('Downloading dataset %s (%s), %s %s... ', D{2}{ii}, currentTask.getDescription(), D{3}{ii}, D{4}{ii});
        
        try
            if(exist(strcat(D{2}{ii}, '.mat'), 'file') == 2)
                cprintf([1,0.5,0], 'ALREADY PRESENT\n');
                res = 2;
            else
                remoteFile = strcat(url, D{1}{ii}, '/', D{2}{ii}, '.zip');
                localDir = fullfile(XmlConfiguration.getRoot(), 'datasets', D{1}{ii});
                unzip(remoteFile, localDir);
                cprintf('comment', 'SUCCESS\n');
                res = 1;
            end
        catch
            cprintf('err', 'FAILURE\n');
            res = 3;
        end
        downloadResults(res) = downloadResults(res) + 1;
        
    end
    
    fprintf('Complete, %i downloaded, %i already present, %i failures.\n', downloadResults);
    if(downloadResults(3) > 0)
        fprintf('Please contact the author for information on the failed datasets\n');
    end

end

end

