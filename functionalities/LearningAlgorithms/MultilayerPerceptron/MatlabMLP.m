% MatlabMLP This is a wrapper to the Multilayer Perceptron  implemented in the Neural Network Toolbox of Matlab
%   This use 'feedforwardnet' for regression tasks, and 'patternnet' for
%   classification tasks. It is trained with Scaled conjugate gradient 
%   backpropagation.
%
%   Internally, this can use the GPU.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef MatlabMLP < LearningAlgorithm
    
    properties
        netStruct;
    end
    
    methods
        
        function obj = MatlabMLP(model, varargin)
            obj = obj@LearningAlgorithm(model, varargin{:});
        end
        
        function p = initParameters(~, p)
        end
        
        function obj = train(obj, Xtr, Ytr)
            
            if(obj.getCurrentTask() == Tasks.R)
                obj.netStruct = feedforwardnet(obj.getParameter('hiddenNodes'));
            else
                obj.netStruct = patternnet(obj.getParameter('hiddenNodes'));
            end
            
            cval = get_partition( Ytr, 0.2 );
            if(obj.getCurrentTask() == Tasks.MC)
                Ytr  = dummyvar(Ytr);
            end
            
            obj.netStruct.divideFcn = 'divideind';
            obj.netStruct.divideParam.trainInd = find(training(cval) == 1); 
            obj.netStruct.divideParam.valInd = find(test(cval)==1);
            obj.netStruct.divideParam.testInd = [];
            
            if(isa(Xtr, 'gpuArray'))
                use_gpu = 'yes';
                obj.netStruct.trainFcn = 'trainscg'; % Default training function does not work with GPU
            else
                use_gpu = 'no';
            end
            
            obj.netStruct.trainParam.showWindow = false;
            obj.netStruct = train(obj.netStruct, Xtr', Ytr', 'useGPU', use_gpu);
        
        end
        
        function b = hasGPUSupport(obj)
            b = true;
        end
        
        function b = checkForCompatibility(~, model)
            b = model.isOfClass('MultilayerPerceptron');
        end
        
        function res = checkForPrerequisites(obj)
            if(~exist('patternnet', 'file') == 2)
                error('Lynx:Runtime:MissingToolbox', 'The MatlabMLP training algorithm requires the Neural Network Toolbox');
            end
            res = true;
        end
        
        function b = hasCustomTesting(obj)
            b = true;
        end
        
        function [labels, scores] = test_custom(obj, Xts)
            if(~isempty(Xts))
                scores = obj.netStruct(Xts')';
                labels = convert_scores(scores, obj.getCurrentTask());
            else
                labels = [];
                scores = [];
            end
            
        end
      
    end
    
    methods(Static)
        function info = getDescription()
            info = 'This is a wrapper to the Multilayer Perceptron implemented in the Neural Network Toolbox of Matlab.';
        end
        
        function pNames = getParametersNames()
            pNames = {}; 
        end
        
        function pInfo = getParametersDescription()
            pInfo = {};
        end
        
        function pRange = getParametersRange()
            pRange = {};
        end 
    end
    
end

