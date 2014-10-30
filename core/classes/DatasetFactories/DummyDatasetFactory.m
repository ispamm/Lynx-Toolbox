% DummyDatasetFactory - Do nothing to the dataset

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef DummyDatasetFactory < DatasetFactory
    
    methods
        function datasets = process(obj, d)
            datasets = {d};
        end
    end
    
end

