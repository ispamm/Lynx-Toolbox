% DatasetFactory - Create one or more datasets from a Dataset object
%   This implements a unique create method to be derived

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef DatasetFactory
    
    methods(Abstract)
        % Create one or more datasets from an existing one
        datasets = process(obj, d);
    end
    
end

