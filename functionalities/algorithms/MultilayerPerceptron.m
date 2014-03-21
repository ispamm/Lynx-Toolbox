classdef MultilayerPerceptron < LearningAlgorithm
    % MULTILAYERPERCEPTRON This is a wrapper to the Multilayer Perceptron 
    %   implemented in the Neural Network Toolbox of Matlab.
    %
    %   The only training parameter is the number of nodes in the hidden
    %   layer:
    %
    %   add_algorithm('NN', 'NNet', @MultilayerPerceptron, 'hiddenNodes', 
    %   15).
    %
    %   Internally, this can use the GPU.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    properties
        netStruct;
    end
    
    methods
        
        function obj = MultilayerPerceptron(varargin)
            obj = obj@LearningAlgorithm(varargin);
        end
        
        function initParameters(~, p)
            p.addParamValue('hiddenNodes', 10, @(x) assert(mod(x,1) == 0 && x > 0, 'Number of hidden nodes of MLP must be > 0'));
        end
        
        function obj = train(obj, Xtr, Ytr)
            
            if(obj.getTask() == Tasks.R)
                obj.netStruct = feedforwardnet(obj.trainingParams.hiddenNodes);
            else
                obj.netStruct = patternnet(obj.trainingParams.hiddenNodes);
            end
            cval = get_partition( Ytr, 0.2 );
            if(obj.getTask() == Tasks.MC)
                Ytr  = dummyvar(Ytr);
            end
            obj.netStruct.divideFcn = 'divideind';
            obj.netStruct.divideParam.trainInd = find(training(cval) == 1); 
            obj.netStruct.divideParam.valInd = find(test(cval)==1);
            obj.netStruct.divideParam.testInd = [];
            
            log = SimulationLogger.getInstance();
            if(log.flags.gpu_enabled)
                use_gpu = 'yes';
                obj.netStruct.trainFcn = 'trainscg'; % Default training function does not work with GPU
            else
                use_gpu = 'no';
            end
            
            obj.netStruct.trainParam.showWindow = false;
            obj.netStruct = train(obj.netStruct, Xtr', Ytr', 'useGPU', use_gpu);
        
        end
        
        function [labels, scores] = test(obj, Xts)
            if(~isempty(Xts))
                scores = obj.netStruct(Xts')';
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
            info = 'This is a wrapper to the Multilayer Perceptron implemented in the Neural Network Toolbox of Matlab.';
        end
        
        function pNames = getParametersNames()
            pNames = {'hiddenNodes'}; 
        end
        
        function pInfo = getParametersInfo()
            pInfo = {'Number of nodes in hidden layer'};
        end
        
        function pRange = getParametersRange()
            pRange = {'Positive integer, default is 10'};
        end 
    end
    
end

