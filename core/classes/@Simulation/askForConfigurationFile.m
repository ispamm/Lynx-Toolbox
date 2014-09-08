function obj = askForConfigurationFile( obj )

% askForConfigurationFile - Ask for a configuration file
%   Files are contained in the ROOT/configs folder.

files = getAllFiles(fullfile(XmlConfiguration.getRoot(), 'configs'));

% Remove non .m files
to_remove = false(length(files), 1);
for i = 1:length(files)
	[~, file, filext] = fileparts(files{i});
    if(~strcmp(filext, '.m'))
        to_remove(i) = true;
    end
end
files(to_remove) = [];

result = -1;
while(~isnumeric(result) || ~(numel(result) == 1)  || result < 1 || result > length(files) )
                 
    cprintf('-text', '\nPlease select a configuration file:\n\n');
    for i = 1:length(files)
        [~, file, ~] = fileparts(files{i});
        info = evalc(sprintf('help %s', file));
        info = strtrim(strrep(info, sprintf('\n'),''));
        fprintf('\t * [%i] %s \n', i, info);
    end
    fprintf('\n');
    
    result = str2double(input('Input your selection: ', 's'));

end

obj.configFile = files{result};
[~, file, ~] = fileparts(files{result});
eval(file);

end

