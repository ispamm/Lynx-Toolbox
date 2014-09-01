function b = isingroup( x, group )
% isingroup - Check that the string x is contained in the cell array group
%
%   Example of usage:
%
%   b = isingroup('a', {'a', 'b'}); returns true
%   b = isingroup('c', {'a', 'b'}); returns false

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it
    
    b = ischar(x) && any(cellfun(@(y) strcmp(x, y), group));

end

