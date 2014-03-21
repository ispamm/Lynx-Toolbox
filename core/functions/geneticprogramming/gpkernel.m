
% Performs a search for the best kernel using a genetic programming
% algorithm
% input: fitness is a pointer to the fitness evaluation function
% output: the best individual, its fitness, and a struct containing some
%         useful statistics.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function [best_ind, best_fitness, statistics] = gpkernel(fitness, varargin)
    
    tic;
    p = inputParser;

    % Parameters for the algorithm
    p.addParamValue('POPULATION_SIZE', 50, @(x)isposint(x));            % Size of the population
    p.addParamValue('MAX_GENERATIONS', 15, @(x)isposint(x));            % Number of generations
    p.addParamValue('REPRODUCTION_RATE', 0.8, @(x) x >= 0 && x <=1);    % Percentage of elements coming from crossing-over
    p.addParamValue('MUTATION_RATE', 0.05, @(x) x >= 0 && x <=1);       % Probability of randomly mutating an element
    p.addParamValue('ELITISM', 4, @(x)isposint(x));                     % Number of best individuals to select in the following generation
    p.addParamValue('TOURNAMENT_SIZE', 2, @(x)isposint(x));             % Size of the tournament used for selection
    p.addParamValue('MAX_KERNEL_DEPTH', 3, @(x)isposint(x));            % Maximum kernel depth
    p.addParamValue('MAX_KERNEL_DEPTH_INIT', 3, @(x)isposint(x));       % Maximum kernel depth during initialization
    p.addParamValue('VERBOSE', true, @(x) x==0 || x==1);                % Whether to print some statistics on each iteration
    p.addParamValue('TOLERANCE', 3, @(x)isposint(x));                   % Number of decimal places to consider in the fitness function
    p.addParamValue('FITNESS_SHARING', true);                           % Whether to enable fitness sharing
    p.parse(varargin{:});
    p = p.Results;
    
    % A patch if population size and tournament size are incompatible
    if(p.TOURNAMENT_SIZE > round(p.POPULATION_SIZE/2))
        p.TOURNAMENT_SIZE = round(p.POPULATION_SIZE/2);
    end
    
    % Set the probabilities of the leaves (should add to 1), the order:
    % linear, polynomial, gaussian, hyperbolic
    leafNodeProb = [0.1 0.3 0.3 0.3];
            
    % Set the probabilities of the internal nodes (should add to 1), the order:
    % shifting, scaling, addition, multiplication, exponentiation
    internalNodeProb = [0.15 0.2 0.3 0.3 0.05];  

    % Initialize the sharing factor
    sharing_factor = 1;
    
    % Elements to be selected in each generation
    nWithNoElitism = p.POPULATION_SIZE - p.ELITISM;
    nToBeSelected = nWithNoElitism - floor(p.REPRODUCTION_RATE*nWithNoElitism);
    
    % Statistics initialization
    statistics.training_time = 0;
    statistics.average_fitness = zeros(1, p.MAX_GENERATIONS);
    statistics.best_fitness = zeros(1, p.MAX_GENERATIONS);
    statistics.entropy = zeros(1, p.MAX_GENERATIONS);
    statistics.edit_distance = zeros(1, p.MAX_GENERATIONS);
    statistics.phen_diversity = zeros(1, p.MAX_GENERATIONS);
    statistics.sharing_factor = zeros(1, p.MAX_GENERATIONS);
    
    statistics.sharing_factor(1) = sharing_factor;
    
    % Best individual so far
    best_ind = [];
    best_fitness = Inf;
    
    % Initialize the population
    pop = initializePopulation(p.POPULATION_SIZE, p.MAX_KERNEL_DEPTH_INIT, leafNodeProb, internalNodeProb);
    
    % Iterate over the generations
    for i=1:p.MAX_GENERATIONS

        % Fitness Computation
        fit = computeFitness(pop, fitness, p.TOLERANCE);
        
        % Check if we have a new minimum for fitness
        [currentMinFitness, currentMinIndex] = min(fit);
        if(currentMinFitness < best_fitness)
            best_fitness = currentMinFitness;
            best_ind = pop{currentMinIndex};
        end
        
        % Delete NaN from fitness (hack)
        nanFitness = isnan(fit);
        fit(nanFitness) = [];
        pop(nanFitness) = [];
        
        % Second hack: delete fitness values that are too large. In some
        % cases this can delete all fitness values (too overfitting), in
        % this case it restores the original values.
        fit_backup = fit;
        pop_backup = pop;
        tooLargeFitness = fit > 3;
        fit(tooLargeFitness) = [];
        pop(tooLargeFitness) = [];
        if(isempty(fit))
            fit = fit_backup;
            pop = pop_backup;
        end
        
        % Save some statistics of the current generation
        statistics.average_fitness(i) = mean(fit);
        statistics.best_fitness(i) = best_fitness;
        
        % Compute the entropy  and phenotipic diversity 
        % of the current population
        [hCount, ~] = hist(round(fit*10^(p.TOLERANCE-1)), 10^(p.TOLERANCE-1));
        hCount = hCount./sum(hCount);
        hCount(hCount == 0) = [];
        statistics.entropy(i) = -sum(hCount.*log(hCount));
        statistics.phen_diversity(i) = length(hCount);
        
        % Compute the edit distance for the current population
        currentEditDistances = zeros(1, length(pop));
        for j=1:length(pop)
            currentEditDistances(j) = computeDistance(pop{j}, best_ind);
        end
        statistics.edit_distance(i) = mean(currentEditDistances);
       
        % Cell array for new population
        newPop = cell(1, p.POPULATION_SIZE);
        
        % Step 1 - Choose the fittest individuals in old population
        [~, idx] = sort(fit, 'ascend');
        for j=1:p.ELITISM
           newPop{j} = pop{idx(j)};
        end
        
        if(p.FITNESS_SHARING)
           
            % First, we compute the pairwise distance between each
            % individual and use it to compute the corresponding sharing
            % factor
            currentPopulationSize = length(pop);
            sharing = zeros(currentPopulationSize, currentPopulationSize);
            pairwiseDistances = zeros(currentPopulationSize, currentPopulationSize);
            for j1=1:currentPopulationSize
                for j2=(j1 + 1):currentPopulationSize
                    pairwiseDistances(j1, j2) = computeDistance(pop{j1}, pop{j2});
                    pairwiseDistances(j2, j1) = pairwiseDistances(j1, j2);
                    if(pairwiseDistances(j1, j2) <= sharing_factor)
                        sharing(j1,j2) = 1-(pairwiseDistances(j1, j2)/sharing_factor).^2;
                    else
                        sharing(j1,j2) = 0;
                    end
                    sharing(j2,j1) = sharing(j1,j2);
                end
            end
            
            % Compute the total sharing of each individual
            sharing = sum(sharing, 2)';
            
            % Normalize the fitness
            fit = fit.*sharing;
            
            % Change the sharing factor
            if(i > 1 && mod(i-1,3) == 0)
                rel_diversity = statistics.entropy(i)/statistics.entropy(i-3);
                rel_fitness = statistics.average_fitness(i)/statistics.average_fitness(i-3);
                
                % If diversity has dropped of more than 50%, increase the
                % sharing factor
                if(rel_diversity < 0.5)
                    sharing_factor = sharing_factor/rel_diversity;
                end
                
                % If average fitness has increased, decrease the sharing
                % factor
                if(rel_fitness > 1)
                    sharing_factor = sharing_factor/rel_fitness;
                end
                
            end
            
            statistics.sharing_factor(i) = sharing_factor;
            
        end
        
        % Print on screen information on current generation
        if(p.VERBOSE)
           fprintf('\t\t Current Generation: %d. Best Fitness = %.5f. Average Fitness = %.5f\n', i, best_fitness, statistics.average_fitness(i)); 
        end
        
        % Step 2 - Select a given percentage of individuals in old
        % population depending on fitness
        nextj = j+1;
        for j=nextj:(nextj+nToBeSelected-1)
            newPop{j} = tournament(pop, fit, p.TOURNAMENT_SIZE);
        end
        
        % Step 3 - Crossing Over
        % Reproduction
        if(nextj ~= j+1) % Needed if reproduction_rate = 1
            nextj = j+1;
        end
        for j=nextj:2:p.POPULATION_SIZE
           
            % Choose the parents
            p1 = tournament(pop, fit, p.TOURNAMENT_SIZE);
            p2 = tournament(pop, fit, p.TOURNAMENT_SIZE);
           
            % Performs crossing over
           [newInd1, newInd2] = crossover(p1, p2, p.MAX_KERNEL_DEPTH);
           newPop{j} = newInd1;
           if(j + 1 <= p.POPULATION_SIZE)
               newPop{j+1} = newInd2;
           end
        end
        
        % Step 4 - Mutation
        for j=1:p.POPULATION_SIZE
           diceRoll = rand();
           if(diceRoll < p.MUTATION_RATE)
              newPop{j} = mutation(newPop{j}, leafNodeProb, internalNodeProb);
           end
        end
        
        pop = newPop;
        clear newPop
        
    end
    statistics.training_time = toc;
    statistics.best_ind = best_ind;

end

function res = isposint(x)
    res = (x>=0)&(mod(x,1)==0);
end