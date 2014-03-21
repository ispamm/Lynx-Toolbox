classdef StackedAutoEncoder < LearningAlgorithm
    
    % STACKEDAUTOENCODER This is a wrapper to the Stacked Deep Autoencoder 
    %   implemented in the DeepLearnToolbox. All parameters are name/value.
    %   To simplify the design, all hidden layers share the same activation
    %   functions, learning rates, and epochs. Hence, the corresponding
    %   parameters are 2x1 vector, where the first element refers to the
    %   hidden layers and the second element to the output layer. Consider
    %   the following example:
    %
    %   add_algorithm('SAE', 'SAE', @StackedAutoEncoder, 'hiddenNodes', [10
    %   10], 'actFunc', {'linear', 'softmax'}).
    %
    %   This identifies a SAE with two hidden layers, and one output
    %   layer. Both the hidden layers have linear activation functions,
    %   whilst the output layer has softmax activation functions.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    properties
        nnStruct;
    end
    
    methods
        
        function obj = StackedAutoEncoder(varargin)
            obj = obj@LearningAlgorithm(varargin);
        end
        
        function initParameters(~, p)
            p.addParamValue('hiddenNodes', 10);
            p.addParamValue('actFunc', {'sigm', 'sigm'}, @(x) assert(iscell(x) && length(x) == 2, 'Activation functions for SAE must be a 2x1 cell array'));
            p.addParamValue('learningRates', [1, 1], @(x) assert(length(x) == 2, 'Learning rates for SAE must be a 2x1 vector'));
            p.addParamValue('noiseFraction', 0.1, @(x) assert(x > 0, 'Noise fraction must be > 0'));
            p.addParamValue('epochs', [10, 10], @(x) assert(length(x) == 2, 'Epochs must be a 2x1 vector of integers'));
            p.addParamValue('batchSize', 15, @(x) assert(mod(x,1) == 1 && x > 0, 'Batch size must be an integer > 0'));
        end
        
        function obj = train(obj, Xtr, Ytr)
            
            if(obj.getTask() == Tasks.MC)
                Ytr  = dummyvar(Ytr);
            end
            
            % Adjust batch size depending on the size of the dataset
            N = size(Xtr, 1);
            x = 1:N;
            divisors = x(~(rem(N, x)))';
            newBatchSize = divisors(knnsearch(divisors, obj.trainingParams.batchSize));
            
            n_hidden = length(obj.trainingParams.hiddenNodes);
            
            sae = saesetup([size(Xtr,2) obj.trainingParams.hiddenNodes]);
            for i=1:n_hidden
                sae.ae{i}.activation_function = obj.trainingParams.actFunc{1};
                sae.ae{i}.learningRate = obj.trainingParams.learningRates(1);
                sae.ae{i}.inputZeroMaskedFraction = obj.trainingParams.noiseFraction;
            end
            
            opts.numepochs = obj.trainingParams.epochs(1);
            opts.batchsize = newBatchSize;
            
            [~, sae] = evalc('saetrain(sae, Xtr, opts)');
            
            obj.nnStruct = nnsetup([size(Xtr,2) obj.trainingParams.hiddenNodes size(Ytr,2)]);
            obj.nnStruct.activation_function = obj.trainingParams.actFunc{2};
            obj.nnStruct.learningRate = obj.trainingParams.learningRates(2);
            
            for i=1:n_hidden
                obj.nnStruct.W{i} = sae.ae{i}.W{1};
            end

            if(obj.getTask() == Tasks.MC)
                cv = get_partition(vec2ind(Ytr)', 0.2);
            else
                cv = get_partition(Ytr, 0.2);
            end
            
            % Adjust (again) batch size depending on the size of the dataset
            N = size(Xtr(training(cv),:), 1);
            x = 1:N;
            divisors = x(~(rem(N, x)))';
            newBatchSize = divisors(knnsearch(divisors, obj.trainingParams.batchSize));
            
            opts.numepochs = obj.trainingParams.epochs(2);
            opts.batchsize = newBatchSize;
            [~, obj.nnStruct] = evalc('nntrain(obj.nnStruct, Xtr(training(cv),:), Ytr(training(cv),:), opts, Xtr(test(cv),:), Ytr(test(cv), :))');
            
        end
        
        function [labels, scores] = test(obj, Xts)
            if(~isempty(Xts))
                [~, obj.nnStruct] = evalc('nnff(obj.nnStruct, Xts, zeros(size(Xts,1), obj.nnStruct.size(end)))');
                scores = obj.nnStruct.a{end};
                labels = convert_scores(scores, obj.getTask());
            else
                labels = [];
                scores = [];
            end
            
        end
        
        function res = isTaskAllowed(~, ~)
            res = true;
        end
    end
    
    methods(Static)
        function info = getInfo()
            info = 'This is a wrapper to the Stacked Deep Autoencoder implemented in the DeepLearnToolbox.';
        end
        
        function pNames = getParametersNames()
            pNames = {'hiddenNodes', 'actFunc', 'learningRates', 'noiseFractions', 'epochs', 'batchSize'}; 
        end
        
        function pInfo = getParametersInfo()
            pInfo = {'Size of the hidden layers', 'Activation functions of the hidden and output layers respectively', 'Learning rates of the hidden and output layers', ...
                'Noise fraction inserted during training' 'Epochs for pre-training and final training', ...
                'Size of the batch to use'};
        end
        
        function pRange = getParametersRange()
            pRange = {'Mx1 vector of integers, default is 10', '1x2 cell array in {sigm, linear, softmax}, default is {sigm, sigm}',...
                '1x2 vector of real positive numbers, default is [1, 1]', ...
                'Real number in [0,1], default is 0.1', '2x1 vector of positive integers, default is [10, 10]', ...
                'Positive integer, default is 15'};
        end 
    end
    
end

