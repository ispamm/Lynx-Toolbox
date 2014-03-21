
% CHECK_AND_INSTALL_LIBRARY Verify if a library is present, and eventally
% install it.
%
%   CHECK_AND_INSTALL_LIBRARY(NAME, FUNC, URL, STRINGONERROR) Searches if
%   library NAME is present by verifying that the function FUNC is
%   available on the path. Is it is not present, downloads the library from
%   URL, otherwise warn the user with the string STRINGONERROR.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function check_and_install_library( lib_name, lib_function, lib_url, stringOnError )

fprintf('Checking for presence of %s...\n', lib_name);
res = exist(lib_function, 'file');
if(res ~= 2 && res ~= 3)
    result = '';
    while(~strcmp(result, 'Y') && ~strcmp(result, 'N'))
        inputString = sprintf('%s not found. Do you want to install it? (Y/N) ', lib_name);
        result = input(inputString, 's');
    end
    if(strcmp(result, 'Y'))
        fprintf('Downloading toolbox... (may take some minutes)\n');
        [~, status] = urlwrite(lib_url, ...
            './tmp/tmp.zip');
        if(status)
           unzip('./tmp/tmp.zip', './lib/'); 
           delete('./tmp/tmp.zip');
           fprintf('Installation of %s succesfull\n', lib_name);
        else
           error('LearnToolbox:FatalError:ToolboxDownloadError', 'There was an error in downloading the toolbox'); 
        end
    else
        warning('LearnToolbox:Warning:ToolboxNotInstalled', stringOnError);
    end
end


end

