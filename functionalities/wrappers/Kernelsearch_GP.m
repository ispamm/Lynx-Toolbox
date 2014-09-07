% Kernelsearch_GP - Searches the optimal kernel function by running a genetic programming routine. 
%
%   For more information on the algorithm, refer to:
%
%   [1] Scardapane, S., Comminiello, D., Scarpiniti, M. and Uncini, A.,
%   "GP-Based Kernel Evolution for L2-Regularization Networks", in 2014
%   IEEE World Congress on Computational Intelligence.
%
%   This has several parameters of the form
% name/value:
%
%   partition_strategy - Partitioning strategy (default KFoldPartition(3))
%   pop_size - Population size (default 50)
%   gen - Number of generations (default 10)
%   reproduction_rate - Percentage of individuals to create by crossover
%   (default 0.9)
%   mutation_rate - Probability of mutation of an individual after
%   generating the new population (default 0.2).
%   elitism - Number of individuals with highest fitness to pass directly
%   into the new population (default 2)
%   t_size - Size of the tournament for selection (default 6)
%   k_depth - Maximum size of the kernel tree (default 6)
%   k_depth_init - Maximum size of the kernel tree during initialization of
%   the population (default 3)
%   tol - Number of decimals to consider in the fitness evaluation (default
%   3)
%   fitness_sharing - Whether to enable a fitness sharing mechanism
%   (default false)
%   final_tuning - 

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef Kernelsearch_GP < Wrapper
    
    properties
        optimalKernel;
        minimumFitness;
        Xtr;
    end
    
    methods
        
        function obj = Kernelsearch_GP(wrappedAlgo, varargin)
            obj = obj@Wrapper(wrappedAlgo, varargin{:});
        end
        
        function p =  initParameters(~, p)
            p.addParamValue('partition_strategy', KFoldPartition(3));
            p.addParamValue('pop_size', 5);
            p.addParamValue('gen', 2);
            p.addParamValue('reproduction_rate', 0.9);
            p.addParamValue('mutation_rate', 0.2);
            p.addParamValue('elitism', 2);
            p.addParamValue('t_size', 6);
            p.addParamValue('k_depth', 6);
            p.addParamValue('k_depth_init', 3);
            p.addParamValue('tol', 3);
            p.addParamValue('fitness_sharing', false);
        end
        
        function obj = train(obj, Xtr, Ytr)
            obj.wrappedAlgo = obj.wrappedAlgo.setParameter('kernel_type', 'custom');
            fitFun = @(k) obj.computeFitnessIndividual( k, Xtr, Ytr );
            
            origC = obj.wrappedAlgo.getParameter('C');
            
            [obj.optimalKernel, obj.minimumFitness, statistics] = gpkernel(fitFun, 'POPULATION_SIZE', obj.parameters.pop_size, ...
                'MAX_GENERATIONS', obj.parameters.gen, ...
                'REPRODUCTION_RATE', obj.parameters.reproduction_rate, ...
                'MUTATION_RATE', obj.parameters.mutation_rate, ...
                'ELITISM', obj.parameters.elitism, ...
                'TOURNAMENT_SIZE', obj.parameters.t_size, ...
                'MAX_KERNEL_DEPTH', obj.parameters.k_depth, ...
                'MAX_KERNEL_DEPTH_INIT', obj.parameters.k_depth_init, ...
                'TOLERANCE', obj.parameters.tol, ...
                'FITNESS_SHARING', obj.parameters.fitness_sharing, ...
                'VERBOSE', SimulationLogger.getInstance().flags.debug);
            
            obj.Xtr = Xtr;
            Omega_train = obj.optimalKernel.evaluate(Xtr, []);
            
            % Find the optimal regularization parameter
            obj.wrappedAlgo = ParameterSweep(obj.wrappedAlgo, {'C'}, {2^-5:10}, 'partition_strategy', obj.parameters.partition_strategy);
            
            obj.wrappedAlgo = obj.wrappedAlgo.setCurrentTask(obj.getCurrentTask());
            obj.wrappedAlgo = obj.wrappedAlgo.train(Omega_train, Ytr);
            
            obj.wrappedAlgo = obj.wrappedAlgo.wrappedAlgo;
            obj.wrappedAlgo = obj.wrappedAlgo.setParameter('C', origC);
            
            obj.statistics = statistics;
            
        end
        
        function b = hasCustomTesting(obj)
            b = true;
        end
        
        function [labels, scores] = test_custom(obj, Xts)
            Omega_test = obj.optimalKernel.evaluate(obj.Xtr, Xts);
            [labels, scores] = obj.wrappedAlgo.test(Omega_test);
        end
        
        function fit  = computeFitnessIndividual(obj, k, X, Y )
            Omega = k.evaluate(X, []);
            data = obj.generateDataset(KernelMatrix(Omega), Y);
            data = data.generateSinglePartition(obj.parameters.partition_strategy);
            fit = PerformanceEvaluator.getInstance().computePerformance(obj.wrappedAlgo, data);
            fit = fit{1}.getFinalizedValue();
        end
        
        function b = checkForCompatibility(obj, model)
            b = model.isOfClass('SupportVectorMachine') || model.isOfClass('RegularizedLeastSquare');
        end
        
        
    end
    
    methods(Static)
        function info = getDescription()
            info = 'Search the optimal kernel using a Genetic Programming search. Base algorithm requires kernel_type = custom';
        end
        
        function pNames = getParametersNames()
            pNames = {'partition_strategy', 'pop_size', 'gen', 'reproduction_rate', ...
                'mutation_rate', 'elitism', 't_size', 'k_depth', 'k_depth_init', ...
                'tol', 'fitness_sharing'};
        end
        
        function pInfo = getParametersInfo()
            pInfo = {'Partitioning strategy for validation', 'Size of the population', 'Number of generations', ...
                'Reproduction rate', 'Mutation rate', 'Degree of elitism', 'Tournament size', ...
                'Maximum kernel depth', 'Maximum kernel depth in initialization' ,...
                'Tolerance of the fitness function', 'Enables fitness sharing'};
        end
        
        function pRange = getParametersRange()
            pRange = {'An object of class PartitionStrategy', 'Positive integer, default 50', 'Positive integer, default 20', ...
                '[0,1], default 0.9', '[0,1], default 0.2', 'Positive integer, default 2', ...
                'Positive integer, default 6', 'Positive integer, default 6', 'Positive integer, default 3', ...
                'Positive integer, default 3', 'Boolean, default false'};
        end
    end
    
end