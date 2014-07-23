classdef ExtremeLearningMachine < LearningAlgorithm
    % EXTREMELEARNINGMACHINE Extreme Learning Machine implemented following
    %   the paper:
    %
    %   [1] Huang, Guang-Bin, et al. 'Extreme learning machine for
    %   regression and multiclass classification.'' Systems, Man, and 
    %   Cybernetics, Part B: Cybernetics, IEEE Transactions on 42.2 (2012):
    %   513-529.
    %
    %   All parameters are name/value:
    %
    %   add_algorithm('ELM', 'ELM', @ExtremeLearningMachine, 'hiddenNodes',
    %   50) changes the default number of nodes in the hidden layer.
    %
    %   add_algorithm('ELM', 'ELM', @ExtremeLearningMachine, 'C', 10) 
    %   changes the regularization parameter.
    %
    %   add_algorithm('ELM', 'ELM', @ExtremeLearningMachine, 'type', 'rbf') 
    %   will allow to change the hidden activation functions, currently the
    %   only possibility is to use RBF functions.
    %
    %   The main operation for training is a hiddenNodes x hiddenNodes
    %   matrix inversion, that can be parallelized on the GPU.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    properties
        weights_l1;
        bias_l1;
        outputWeights;
    end
    
    methods
        
        function obj = ExtremeLearningMachine(varargin)
            obj = obj@LearningAlgorithm(varargin);
        end
        
        function initParameters(~, p)
            p.addParamValue('hiddenNodes', 50, @(x) assert(mod(x,1) == 0 && x > 0, 'Hidden nodes of ELM must be an integer > 0'));
            p.addParamValue('C', 1, @(x) assert(x > 0, 'Regularization parameter of RN must be > 0'));
            p.addParamValue('type', 'rbf', @(x) assert(ischar(x), 'Type of ELM must be a string'));
        end
        
        function obj = train(obj, Xtr, Ytr)

            [N, d] = size(Xtr);
            N_hidden = obj.trainingParams.hiddenNodes;
            
            if(obj.getTask() == Tasks.MC)
                Ytr  = dummyvar(Ytr);
            end

            log = SimulationLogger.getInstance();
            
            if(log.flags.gpu_enabled)
                weightsl1 = gpuArray.rand(N_hidden, d)*2-1;
                biasl1 = gpuArray.rand(N_hidden,1)*2-1;
                Xtr = gpuArray(Xtr);
                Ytr = gpuArray(Ytr);
            else
                weightsl1 = rand(N_hidden, d)*2-1;
                biasl1 = rand(N_hidden,1)*2-1;
            end
            
            H = weightsl1*Xtr';
            clear Xtr
            
            H = bsxfun(@plus, H, biasl1);

            if(strcmp(obj.trainingParams.type, 'rbf'))
                H = 1 ./ (1 + exp(-H));
                H = H';
            end
            
            if(N >= N_hidden)
                outputWeightsCopy = (eye(N_hidden)./obj.trainingParams.C + H' * H) \ ( H' * Ytr );
            else
                outputWeightsCopy = H'*inv(eye(size(H, 1))./obj.trainingParams.C + H * H') *  Ytr ;
            end
            
            clear H
             
            if(log.flags.gpu_enabled)
                outputWeightsCopy = gather(outputWeightsCopy);
                biasl1 = gather(biasl1);
                weightsl1 = gather(weightsl1);
            end
            
            obj.outputWeights = outputWeightsCopy;
            obj.bias_l1 = biasl1;
            obj.weights_l1 = weightsl1;
            
        end
        
        function [labels, scores] = test(obj, Xts)
            
            H_temp_test = obj.weights_l1*Xts';
            clear Xts
            H_temp_test = bsxfun(@plus, H_temp_test, obj.bias_l1);
            
            if(strcmp(obj.trainingParams.type, 'rbf'))
                H_temp_test = 1 ./ (1 + exp(-H_temp_test));
            end
    
            scores =(H_temp_test' * obj.outputWeights);
            labels = convert_scores(scores, obj.getTask());
            
        end
        
        function res = isTaskAllowed(~, ~)
            res = true;
        end
    end
    
    methods(Static)

        function info = getInfo()
            info = ['Extreme Learning Machine trained using L2-regularized ridge regression. For more information, ' ...
                'please refer to the following paper: Huang, Guang-Bin, et al. ''Extreme learning machine for regression and multiclass classification.'' Systems, Man, and Cybernetics, Part B: Cybernetics, IEEE Transactions on 42.2 (2012): 513-529.'];
        end
        
        function pNames = getParametersNames()
            pNames = {'hiddenNodes', 'C', 'type'}; 
        end
        
        function pInfo = getParametersInfo()
            pInfo = {'Number of hidden nodes', 'Regularization factor', 'Family of hidden nodes'};
        end
        
        function pRange = getParametersRange()
            pRange = {'Integer > 0, default is 50', 'Positive real number, default is 1', 'String in {rbf}, default is rbf'};
        end    
    end
    
end

