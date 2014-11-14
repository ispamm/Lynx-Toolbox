% RemoveMissingData - Remove rows with missing data
%   This preprocessor removes any row in a dataset where at least one entry
%   is missing (i.e. NaN).

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef RemoveMissingData < Preprocessor
    
    properties
    end
    
    methods
        
        function obj = RemoveMissingData(varargin)
            obj = obj@Preprocessor(varargin{:});
        end
        
        function p = initParameters(obj, p)
        end
        
        function [dataset, obj] = process( obj, dataset )
            rowsWithNaN = any(isnan(dataset.X.data'));
            dataset.X.data(rowsWithNaN, :) = [];
            dataset.Y.data(rowsWithNaN, :) = [];
            
            if(isempty(dataset.X.data))
                error('Lynx:Runtime:EmptyDataset', 'Dataset %s was left empty after removing missing data', dataset.name);
            end
            
            fprintf('RemoveMissingData: deleted %i rows from dataset %s\n', sum(rowsWithNaN), dataset.name);
        end
        
        function dataset = processAsBefore(obj, dataset)
            dataset = obj.process(dataset);
        end
        
    end
    
    methods(Static)
        
        function info = getDescription()
            info = 'Remove missing rows from the dataset';
        end
        
    end
    
end

