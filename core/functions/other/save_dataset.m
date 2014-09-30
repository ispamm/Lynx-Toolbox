function save_dataset( dataset, name )
% save_dataset - Save dataset on the corresponding folder
% Inputs:
%   - d is a Dataset object
%   - name is the name for the new file to be created

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

t = dataset.task;

folder = fullfile(XmlConfiguration.getRoot(), 'datasets', char(t));
fileName = fullfile(folder, [name, '.mat']);

if(exist(fileName, 'file') == 2)
    error('Lynx:Runtime:FileAlreadyExisting', 'A dataset with name %s is already present', name);
end

save(fileName, 'dataset');
fprintf('Successfully saved on disk\n');

end

