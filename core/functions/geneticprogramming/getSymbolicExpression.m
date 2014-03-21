function [variables, fncPointer] = getSymbolicExpression( k )
%GETSYMBOLICEXPRESSION Returns a pointer to a function representing the
%kernel, defined in terms of symbolic variables.
%
%   [VARS, FCN] = GETSYMBOLICEXPRESSION(K) return a pointer FCN and the
%   variables VARS on which it is defined.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

syms x y
variables = [x, y];

fncPointer = k.getSymbolicFunction(x, y);

end

