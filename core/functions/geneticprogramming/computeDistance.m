
% COMPUTEDISTANCE Compute an edit-2 similarity between two kernels, see: 
% Burke, Edmund K., Steven Gustafson, and Graham Kendall. "Diversity in
% genetic programming: An analysis of measures and correlation with  
% fitness." Evolutionary  Computation, IEEE Transactions on 8.1 (2004): 
% 47-62.
%
%   D = COMPUTEDISTANCE(K1, K2) returns the distance D between the kernels
%   K1 and K2. The distance between two nodes is 0 if they are of the same
%   class and 1 otherwise. If at least one of the two is non-terminal, the
%   two kernels are superimposed (eventually by completing them with some
%   "dummy" nodes. Then, the final distance is given by the sum of the
%   distance at the root plus half of the distances of their childs.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function d = computeDistance( k1, k2 )

    % function_distance = 'tree_distance';
    function_distance = 'tree_distance';

    % The distance between the root depend only on their type
    if(~strcmp(class(k1), class(k2)))
        d = 1;
    else
        d = 0;
    end
    
    % the distance of tree 
    if(strcmp(function_distance,'tree_distance'))

        % If at least one tree has a child, we recursively compute their
        % distance
        if(~(k1.isTerminal && k2.isTerminal))
            subDist = 0;

            if(k2.isTerminal)
                subDist = subDist + computeDistance(k1.leftNode, NullKernel());
                if(k1.nArity > 1)
                    subDist = subDist + computeDistance(k1.rightNode, NullKernel());
                end
            elseif(k1.isTerminal)
                subDist = subDist + computeDistance(NullKernel(), k2.leftNode);
                if(k2.nArity > 1)
                    subDist = subDist + computeDistance(NullKernel(), k2.rightNode);
                end
            else
                subDist = subDist + computeDistance(k1.leftNode, k2.leftNode);
                if(k1.nArity > 1 || k2.nArity > 1)
                    if(k1.nArity > 1 && k2.nArity > 1)
                        subDist = subDist + computeDistance(k1.rightNode, k2.rightNode);
                    elseif(k1.nArity > 1)
                        subDist = subDist + computeDistance(k1.rightNode, NullKernel());
                    else
                        subDist = subDist + computeDistance(NullKernel(), k2.rightNode);
                    end
                end
            end
            d = d + 0.5*subDist;   
        end
    % the distance of functions in functional space
    elseif(strcmp(function_distance,'funct_space_distance'))
        [v1,f1] = getSymbolicExpression(k1);
        [v2,f2] = getSymbolicExpression(k2);
        t1 = taylor(f1,v1,'Order', function_distance);
        t2 = taylor(f2,v2,'Order', function_distance);
        d = norm(t1-t2);
    end
end

