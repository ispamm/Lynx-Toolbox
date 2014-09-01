% LabeledMatrix - A matrix with labels on rows and columns
%   This is a commodity class for a matrix having labels on rows and
%   columns. Simply initialize it as:
%
%   l = LabeledMatrix(matrix, row_labels, column_labels);
%
%   If the labels are the same for rows and columns:
%
%   l = LabeledMatrix(matrix, labels),
%
%   Finally, if no labels are provided, they are set to empty:
%
%   l = LabeledMatrix(matrix);

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef LabeledMatrix
    
    properties
        matrix;         % Numerical matrix
        row_labels;     % Labels on the rows
        column_labels;  % Labels on the columns
    end
    
    methods
        
        function obj = LabeledMatrix(matrix, row_labels, column_labels)
            % Construct the LabeledMatrix object
            if(nargin < 2)
                obj.row_labels = [];
                obj.column_labels = [];
            elseif(nargin < 3)
                obj.row_labels = row_labels;
                obj.column_labels = row_labels;
            else
                obj.row_labels = row_labels;
                obj.column_labels = column_labels;
            end
            obj.matrix = matrix;
        end
    end
    
end

