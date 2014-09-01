% FormatAsTable - Display a table of numerical values as an ASCII table
%   This is a possible output formatter for numerical value containers.

classdef FormatAsTable < OutputFormatter
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    methods(Static)
        
        function displayOnConsole(valuesCellArray, row_labels, column_labels)
            
            valuesCellArray = cellfun(@(x) x.formatForOutput, valuesCellArray, 'UniformOutput', false);
            disptable(valuesCellArray, column_labels, row_labels);
            
        end
    end
    
end

