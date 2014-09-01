function b = isinrange( X, arg1, arg2, arg3 )
% isinrange - Check that a number is in a given range.
%
%   B = ISINRANGE(X, a, b) returns true if a <= X <= b
%
%   B = ISINRANGE(X, a, b, false) returns true if the inequalities are
%   strict, i.e. a < X < b
%
%   B = ISINRANGE(X) check for the range [0, 1]
%
%   B = ISINRANGE(X, false) check for the range ]0, 1[

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

    if(nargin < 3)
        minX = 0;
        maxX = 1;
        if(nargin == 1)
            eq = true;
        else
            eq = arg1;
        end
    else
        minX = arg1;
        maxX = arg2;
        
        if(nargin == 3)
            eq = true;
        else
            eq = arg3;
        end
    end
    
    if(eq)
        b = (X >= minX) && (X <= maxX);
    else
        b = (X > minX) && (X < maxX);
    end

end

