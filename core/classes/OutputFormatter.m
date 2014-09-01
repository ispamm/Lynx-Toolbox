% OutputFormatter - Format a table of values on output
%   An OutputFormatter allows to format a table of values on the
%   screen. It provides a single static method.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef OutputFormatter
    
    methods(Static)
        % Display the values contained in the cell array.
        displayOnConsole(valuesCellArray, row_labels, column_labels);
    end
    
end

