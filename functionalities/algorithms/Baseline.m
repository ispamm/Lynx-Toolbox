classdef Baseline < LearningAlgorithm
    %BASELINE Dummy learning algorithm, should be used only as a baseline
    %   for error rates. For regression tasks, it always returns the 
    %   average values of the input data in the training set. For 
    %   classification, it returns random labels in the same proportions
    %   as the input data. This has no training parameters.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    properties
        avValue;        % Mean value for regression
        distribution;   % Output distribution for classification
        values;         % Classes
    end
    
    methods
        
        function obj = Baseline(varargin)
            obj = obj@LearningAlgorithm({});
        end
        
        function p = initParameters(~, p)
        end
        
        function obj = train(obj, ~, Ytr)
            if(obj.trainingParams.task == Tasks.R)
                obj.avValue  = mean(Ytr);
            else
                [obj.distribution, obj.values] = hist(Ytr, unique(Ytr));
                obj.distribution = obj.distribution./norm(obj.distribution,1);
            end
        end
        
        function [labels, scores] = test(obj, Xts)
            if(obj.trainingParams.task == Tasks.R)
                labels = obj.avValue*ones(size(Xts, 1), 1);
                scores = labels;
            else
                samp = discretesample(obj.distribution, size(Xts, 1))';
                labels = obj.values(samp);
                scores = labels;
            end
            
        end
        
        function res = isTaskAllowed(~, ~)
            res = true;
        end
    end
    
    methods(Static)
        function info = getInfo()
            info = ['Dummy learning algorithm, should be used only as a baseline for error rates. ' ...
                'For regression tasks, it always returns the average values of the input data in the training set. ' ...
                'For classification, it returns random labels in the same proportions as the input data.'];
        end
        
        function pNames = getParametersNames()
            pNames = {}; 
        end
        
        function pInfo = getParametersInfo()
            pInfo = {};
        end
        
        function pRange = getParametersRange()
            pRange = {};
        end
    end
    
end

