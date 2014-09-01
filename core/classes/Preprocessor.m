% Preprocessor - An abstract class for creating a preprocessor 
%   A preprocessor is applied to a dataset before training the
%   algorithms.
%
% Preprocessor Methods
%
%   process - Given a dataset, applies a given transformation and
%   returns the new dataset.
%   processAsBefore - Process the dataset using the same configuration as
%   the previous call to process.
%
% See also: Parameterized, Dataset

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef Preprocessor < Parameterized

    methods

        function obj = Preprocessor(varargin)
            obj = obj@Parameterized(varargin{:});
        end
        
    end
    
    methods(Abstract=true)
        dataset = process(obj, dataset);
        dataset = processAsBefore(obj, dataset);
    end
    
end

