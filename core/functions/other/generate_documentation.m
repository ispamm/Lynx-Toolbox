function generate_documentation()
% generate_documentation - Generate the documentation

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

if(~strcmp(XmlConfiguration.getRoot(), pwd))
    error('Lynx:Runtime:Documentation', 'You must run the generate_documentation() script from the root folder of the toolbox');
end

b = LibraryHandler.checkAndInstallLibrary('m2html', 'M2HTML', 'http://www.artefact.tk/software/matlab/m2html/m2html.zip', 'Generating the documentation');

if(~b)
    error('Lynx:Runtime:MissingLibrary', 'Aborted by user');
end

docFolder = fullfile(XmlConfiguration.getRoot(), 'doc');

if( exist(docFolder,'dir') == 7 )
    fprintf('Removing previous documentation files...\n');
    rmdir(docFolder, 's');
end

mkdir(docFolder);

fprintf('Generating documentation...\n');
m2html('mfiles', {'core', 'functionalities'}, ...
    'htmldir', 'doc', 'recursive','on', 'global', 'on');

fprintf('You can find the documentation in the ''doc'' folder.\n<a href="%s">Open the documentation now</a>\n', ...
    fullfile(XmlConfiguration.getRoot(), 'doc', 'index.html'));

end

