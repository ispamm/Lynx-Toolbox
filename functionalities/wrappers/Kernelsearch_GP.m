classdef Kernelsearch_GP < Wrapper
    % KERNELSEARCH_GP Searches the optimal kernel function by running a
    % genetic programming routine.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    properties
        optimalKernel;
        minimumFitness;
        Xtr;
    end
    
    methods
        
        function obj = Kernelsearch_GP(wrappedAlgo, varargin)
            obj = obj@Wrapper(wrappedAlgo, varargin);
        end
        
        function initParameters(~, p)
            p.addParamValue('valParam', 3);
            p.addParamValue('pop_size', 70);
            p.addParamValue('gen', 50);
            p.addParamValue('reproduction_rate', 0.9);
            p.addParamValue('mutation_rate', 0.2);
            p.addParamValue('elitism', 2);
            p.addParamValue('t_size', 6);
            p.addParamValue('k_depth', 6);
            p.addParamValue('k_depth_init', 3);
            p.addParamValue('tol', 3);
            p.addParamValue('fitness_sharing', false);
            p.addParamValue('final_tuning', false);
        end

        function obj = train(obj, Xtr, Ytr)
            obj.wrappedAlgo = obj.wrappedAlgo.setTrainingParam('kernel_type', 'custom');
            fitFun = @(k) obj.computeFitnessIndividual( k, Xtr, Ytr );

            origC = obj.wrappedAlgo.getTrainingParam('C');
            
            [obj.optimalKernel, obj.minimumFitness, statistics] = gpkernel(fitFun, 'POPULATION_SIZE', obj.trainingParams.pop_size, ...
                'MAX_GENERATIONS', obj.trainingParams.gen, ...
                'REPRODUCTION_RATE', obj.trainingParams.reproduction_rate, ...
                'MUTATION_RATE', obj.trainingParams.mutation_rate, ...
                'ELITISM', obj.trainingParams.elitism, ...
                'TOURNAMENT_SIZE', obj.trainingParams.t_size, ...
                'MAX_KERNEL_DEPTH', obj.trainingParams.k_depth, ...
                'MAX_KERNEL_DEPTH_INIT', obj.trainingParams.k_depth_init, ...
                'TOLERANCE', obj.trainingParams.tol, ...
                'FITNESS_SHARING', obj.trainingParams.fitness_sharing, ...
                'VERBOSE', SimulationLogger.getInstance().flags.debug);
            
            obj.Xtr = Xtr;
            Omega_train = obj.optimalKernel.evaluate(Xtr, []);
            
            % Find the optimal regularization parameter
            obj.wrappedAlgo = ParameterSweep(obj.wrappedAlgo, obj.trainingParams.valParam, {'C'}, {'exp'}, [-5 10], [1]);
            
            obj.wrappedAlgo.verbose = obj.verbose;
            obj.wrappedAlgo = obj.wrappedAlgo.setTask(obj.getTask());
            obj.wrappedAlgo = obj.wrappedAlgo.train(Omega_train, Ytr);
            
            obj.wrappedAlgo = obj.wrappedAlgo.wrappedAlgo;
            obj.wrappedAlgo = obj.wrappedAlgo.setTrainingParam( 'C', origC);
            
            obj.statistics = statistics;
            
        end
    
        function [labels, scores] = test(obj, Xts)
            Omega_test = obj.optimalKernel.evaluate(obj.Xtr, Xts);
            [labels, scores] = obj.wrappedAlgo.test(Omega_test);
        end
        
        function fit  = computeFitnessIndividual(obj, k, X, Y )

            Omega = k.evaluate(X, []);
            data = Dataset('a', 'a', obj.getTask(), Omega, Y, true);
            data = data.generateNPartitions(1, obj.trainingParams.valParam);
            fit = mean(eval_algo(obj.wrappedAlgo, data));
        
        end
     

    end
            
    methods(Static)
        function info = getInfo()
            info = 'Search the optimal kernel using a Genetic Programming search. Base algorithm requires kernel_type = custom';
        end
        
        function pNames = getParametersNames()
            pNames = {'valParam', 'pop_size', 'gen', 'reproduction_rate', ...
                'mutation_rate', 'elitism', 't_size', 'k_depth', 'k_depth_init', ...
                'tol', 'fitness_sharing', 'final_tuning'}; 
        end
        
        function pInfo = getParametersInfo()
            pInfo = {'Validation type', 'Size of the population', 'Number of generations', ...
                'Reproduction rate', 'Mutation rate', 'Degree of elitism', 'Tournament size', ...
                'Maximum kernel depth', 'Maximum kernel depth in initialization' ,...
                'Tolerance of the fitness function', 'Enables fitness sharing', 'Enables final tuning'};
        end
        
        function pRange = getParametersRange()
            pRange = {'[0, 1] or positive integer, default 3', 'Positive integer, default 70', 'Positive integer, default 50', ...
                '[0,1], default 0.9', '[0,1], default 0.2', 'Positive integer, default 2', ...
                'Positive integer, default 6', 'Positive integer, default 6', 'Positive integer, default 3', ...
                'Positive integer, default 3', 'Boolean, default false', 'Boolean, default false'};
        end
    end
    
end