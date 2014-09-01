% DummyDatasetFactory - Load the .mat file with no further processing

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef DummyDatasetFactory < DatasetFactory
    
    methods
        function datasets = create(obj, task, data_id, data_name, o)
            datasets = {Dataset(data_id, data_name, task, o.X, o.Y)};
        end
    end
    
end

