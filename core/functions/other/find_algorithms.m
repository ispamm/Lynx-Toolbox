
%FIND_ALGORITHMS Return the IDs of the learning algorithms of a given 
% class currently stored in the Logger.
%
%   IDS = FIND_ALGORITHMS(S) returns a vector of integers, one for each
%   object of class S currently stored in the Logger.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function [ algorithmIDs ] = find_algorithms( classString, algorithms )

algorithmIDs = [];
if(isempty(algorithms))
    return;
end

N_algo = length(algorithms);

for i=1:N_algo
    if(algorithms(i).model.isOfClass(classString))
        algorithmIDs = [algorithmIDs i];
    end
end


end

