
% INFO_PERFMEASURES Generate an HTML report on the available performance
% measures.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

clc;
fprintf('--- AVAILABLE PERFORMANCE MEASURES ---\n\n');

% list of all (sub)folders and files in folder "algorithms":
flist = getAllFiles('../functionalities/performance/');
 
% prepare the result
filterlist = struct('Classname',{});
 
% loop through all the found files and check whether they are classes 
for i=1:numel(flist)
   [~,filename,fileext]=fileparts(flist{i}); % get just the filename
   if (exist(filename,'class') == 8) && (strcmp(fileext,'.m'))
        if exist(filename, 'class') && ismember('PerformanceMeasure', superclasses(filename))
            filterlist(end+1) = struct('Classname',filename);
        end
   end
end

for i=1:length(filterlist)
    info = eval(strcat(filterlist(i).Classname, '.getInfo();'));
    cprintf('*text', filterlist(i).Classname);
    fprintf(': %s\n', info);
end

fprintf('\n');