
% INITIALIZEPOPULATION Initialize a population of a given number of
% elements, with a maximum individual depth provided by the user

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function pop = initializePopulation( popSize, maxDepth, leafNodeProb, internalNodeProb)
    
    pop = cell(1, popSize);
    
    oneThirdN = floor(popSize/3);
    
    % We initialize some elements of the population to some basic kernels
    for i=1:oneThirdN
        pop{i} = growKernel(1, true, leafNodeProb, internalNodeProb);
    end
    
    % Another third is initialized with some basic combinations of kernels
    curri = i;
    for i=(curri+1):curri+oneThirdN
        pop{i} = growKernel(2, true, leafNodeProb, internalNodeProb);
    end
    
    % The last third is made of elements up to the maximum depth
    curri = i;
    for i=(curri+1):popSize
        pop{i} = growKernel(maxDepth, true, leafNodeProb, internalNodeProb);
    end

end

