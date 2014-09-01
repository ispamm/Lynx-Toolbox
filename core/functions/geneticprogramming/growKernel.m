
% growKernel - Grow a random kernel of given maximum depth
% See L. Dio?an, A. Rogozan, and J.-P. Pecuchet, “Improving classification
% performance of Support Vector Machine by genetically optimising kernel 
% shape and hyper-parameters,” Appl. Intell., vol. 36, no. 2, pp. 280–294, 
% Oct. 2010 for the choice of the parameters.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function kernel = growKernel( max_depth, force_max_depth, leafNodeProb, internalNodeProb )

    if(nargin < 4)
        internalNodeProb = ones(5,1)./5;
    end
    if(nargin < 3)
        leafNodeProb = ones(4,1)./4;
    end

    if(~force_max_depth)
        % Probability of adding a terminal or an internal node
        nodeProb = rand();
    end
    
    % We add a terminal node
    if(max_depth == 1 || (~force_max_depth && nodeProb < 0.3) )
        
        % Probability for choosing the leaf node
        kernelTypeProb = rand();
        
        p = cumsum(leafNodeProb);
        sump = round(p(end)*10^3)/10^3;
        assert(sump == 1.0, 'K:ProbError', 'The probabilities of choosing a leaf node should add to 1');
        
        if(kernelTypeProb < p(1)) % We add a linear kernel
            kernel = PolyKernel(1);
        elseif(kernelTypeProb < p(2)) % We add a polynomial kernel
            kernel = PolyKernel(randi(15));
        elseif(kernelTypeProb < p(3)) % We add a Gaussian kernel
            kernel = GaussKernel(getRandomSigma());
        else % We add an hyperbolic kernel
            kernel = HyperbolicKernel(getRandomSigma(), 10^(randi(3) - 2));
        end
    
    else
        
        % Probability for choosing the internal node
        kernelOperatorProb = rand();

        p = cumsum(internalNodeProb);
        sump = round(p(end)*10^3)/10^3;
        assert(sump == 1, 'K:ProbError', 'The probabilities of choosing an internal node should add to 1');
        
        if(kernelOperatorProb < p(1)) % We shift the kernel
            kernel = ShiftingOperator(growKernel(max_depth-1, force_max_depth, leafNodeProb, internalNodeProb), [], rand());
        elseif(kernelOperatorProb < p(2)) % We scale the kernel
            kernel = ScalingOperator(growKernel(max_depth-1, force_max_depth, leafNodeProb, internalNodeProb), [], rand());
        elseif(kernelOperatorProb < p(3)) % We add two kernels
            kernel = PlusOperator(growKernel(max_depth-1, force_max_depth, leafNodeProb, internalNodeProb), growKernel(max_depth-1, force_max_depth, leafNodeProb, internalNodeProb));
        elseif(kernelOperatorProb < p(4)) % We multiply two kernels
            kernel = MultOperator(growKernel(max_depth-1, force_max_depth, leafNodeProb, internalNodeProb), growKernel(max_depth-1, force_max_depth, leafNodeProb, internalNodeProb));
        else % We take the exponential of a kernel
            kernel = ExpOperator(growKernel(max_depth-1, force_max_depth, leafNodeProb, internalNodeProb), []);
        end
    end
    
    function sigma = getRandomSigma()
        sigma = randi(9)*10^(-randi(5));
    end
    
end