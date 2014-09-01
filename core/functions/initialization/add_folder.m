function add_folder( t, fold )
% ADD_FOLDER Add a folder containing datasets
%   Example of use:
%
%   add_folder(Tasks.R, 'C:/MyDatasets') will add the folder 'MyDatasets'
%   as possible source for regression datasets

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

task = Tasks.getById(t);
task.addFolder(fold);

end

