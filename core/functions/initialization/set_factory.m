% set_factory - Change the factory for a task
%   This changes the default DatasetFactory for a particular task.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function set_factory(t, f)

task = Tasks.getById(t);
task.setDatasetFactory(f);

end