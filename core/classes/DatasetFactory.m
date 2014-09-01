% DatasetFactory - Create one or more datasets from a .mat file
%   This implements a unique create method to be derived

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef DatasetFactory
    
    methods(Abstract)
        % Create a dataset from a loaded .mat file
        datasets = create(obj, task, dID, data_name, o);
    end
    
end

