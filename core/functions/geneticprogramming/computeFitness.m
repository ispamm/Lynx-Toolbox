
% COMPUTEFITNESS Compute the fitness of population using the fitness
% function given by the user, up to a given precision

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function fit = computeFitness( pop, fitness, tolerance )

    N = length(pop);
    fit = zeros(1, N);

    tol = 10^(tolerance);
    
    for i=1:N
        
        fit(i) = ...
            round(fitness(pop{i})*tol)/tol;
    
    end

end

