
% find_algorithms - Return the IDs of the learning algorithms of a given 
% class currently stored in the Simulation.
%
%   IDS = FIND_ALGORITHMS(S) returns a vector of integers, one for each
%   object of class S currently stored in the Logger.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function [ algorithmIDs, algorithmNames ] = find_algorithms( classString, algorithms )

algorithmIDs = [];
algorithmNames = {};
if(isempty(algorithms))
    return;
end

N_algo = length(algorithms);

for i=1:N_algo
    if(algorithms.get(i).isOfClass(classString))
        algorithmIDs = [algorithmIDs i];
        algorithmNames{end + 1} = algorithms.get(i).name;
    end
end


end

