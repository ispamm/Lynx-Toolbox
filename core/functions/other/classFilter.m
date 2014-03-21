function classes = classFilter( folder, c )
%CLASSFILTER Return a list of all the classes of class C inside folder F.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

% list of all (sub)folders and files in folder:
flist = getAllFiles(folder);

% prepare the result
classes = struct('Classname',{});
 
% loop through all the found files and check whether they are classes 
for i=1:numel(flist)
   [~,filename,fileext]=fileparts(flist{i}); % get just the filename
   if (exist(filename,'class') == 8) && (strcmp(fileext,'.m'))
        if exist(filename, 'class') && ismember(c, superclasses(filename))
            classes(end+1) = struct('Classname',filename);
        end
   end
end

end

