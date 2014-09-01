
% tournament - Perform a lexicografic tournament selection.
%
%   IND = TOURNAMENT(POP, FIT, SIZE) SIZE individuals are extracted from
%   the population POP. Then, the fittest one between them is returned. If
%   more than one selected individual share the same fitness, the one with
%   smaller length is returned.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function ind = tournament(pop, fit, tournament_size)

    % Choose the individuals to be tested
    candidatesIndexes = randsample(length(pop), tournament_size);
    candidatesIndexes = sort(candidatesIndexes, 'ascend');
    candidatesIndexesLogical = zeros(1,length(pop));
    candidatesIndexesLogical(candidatesIndexes) = 1;
    candidatesIndexesLogical = logical(candidatesIndexesLogical);
    
    % Find the candidate with best fitness
    [minValue, ~] = min(fit(candidatesIndexesLogical));
    bestCandidatesIndexesLogical = (fit(candidatesIndexesLogical) == minValue);
    bestCandidatesIndexes = candidatesIndexes(bestCandidatesIndexesLogical);
    
    % If more than one candidate has the same fitness, performs a
    % lexicographic comparison
    nCand = length(bestCandidatesIndexes);
    
    if(nCand > 1)
        
        % Check the length of each candidate
       candLength = zeros(1, nCand);
       candidates = pop(bestCandidatesIndexes);
       
       for i=1:nCand
           candLength(i) = candidates{i}.length();
       end
       
       % Choose the candidate with lowest length
       [~, minIndex] = min(candLength);
       ind = pop{bestCandidatesIndexes(minIndex)};

    else
        
        % The only individual with minimum fitness
        ind = pop{bestCandidatesIndexes};
        
    end
end