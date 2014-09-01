% FormatAsLabeledSequentialMatrices - Display matrices sequentially
%   This is a possible output formatter for the type LabeledMatrix.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef FormatAsLabeledSequentialMatrices < OutputFormatter
    
    methods(Static)
        
        function displayOnConsole(valuesCellArray, row_labels, column_labels)
            
            N_r = length(row_labels);
            N_c = length(column_labels);
            
            for ii = 1:N_r
                for jj = 1:N_c
                    value = valuesCellArray{ii,jj};
                    if(~value.isEmpty())
                        fprintf('%s / %s\n', row_labels{ii}, column_labels{jj});
                        disptable(value.getFinalizedValue().matrix, cellstr(num2str(value.getFinalizedValue().column_labels)), cellstr(num2str(value.getFinalizedValue().row_labels)));
                    end
                end
            end
            
        end
    end
    
end

