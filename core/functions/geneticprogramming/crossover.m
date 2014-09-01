
% crossover - Performs a crossing over on the two parents. The depth of the 
% resulting individual is limited by a parameter provided by the user

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function [newInd1, newInd2] = crossover( parent1, parent2, maxDepth )

    % Choose random nodes on the parents
    lengthParent1 = parent1.length();
    lengthParent2 = parent2.length();
    
    crossOverPoint1 = randi(lengthParent1);
    crossOverPoint2 = randi(lengthParent2);
    
    % Get the n-th node
    nthNode2 = parent2.getNthNode(crossOverPoint2);
    nthNode1 = parent1.getNthNode(crossOverPoint1);
    
    newInd1 = parent1.setNthNode(crossOverPoint1, nthNode2);
    newInd1 = newInd1.prune(maxDepth);
    
    newInd2 = parent2.setNthNode(crossOverPoint2, nthNode1);
    newInd2 = newInd2.prune(maxDepth);
    
    
end

