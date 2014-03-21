function b = isnatural( x, nonZero )
%ISNATURAL Check that a number is a natural number. Return a boolean.
%
%   B = ISNATURAL(X) returns true if X is a natural number, false
%   otherwise.
%
%   B = ISNATURAL(X, TRUE) additionally check that X is nonzero.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

    if(nargin < 2)
        nonZero = false;
    end

    b = isnumeric(x) && (x >= 0) && (mod(x,1) == 0);
    
    if(nonZero)
        b = b && (x ~= 0);
    end

end

