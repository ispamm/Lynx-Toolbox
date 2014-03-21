
% MUTATION Mutate a random node of an individual by growing a new kernel

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function newInd = mutation( ind, leafNodeProb, internalNodeProb )

    lengthInd = ind.length();
    mutationPoint = randi(lengthInd);
    maxNewDepth = ind.getNthNode(mutationPoint).depth();
    newInd = ind.setNthNode(mutationPoint, growKernel(maxNewDepth, false, leafNodeProb, internalNodeProb));

end

