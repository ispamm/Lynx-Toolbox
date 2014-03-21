classdef Adaboost < LearningAlgorithm
    % ADABOOST This is a wrapper to the Adaboost classifier included in the
    %   Statistics Toolbox of Matlab. It uses decision trees as base 
    %   learners, and trains the following models: Adaboost.M1 for binary 
    %   classification, Adaboost.M2 for multiclass classification, and
    %   Adaboost.LSBoost (Least Square Boosting) for regression. You can 
    %   get additional information on its design by calling 
    %   doc fitensemble. The only possible parameter is given by the
    %   number of learners:
    %
    %   add_algorithm('A', 'Adaboost', @Adaboost, 'nLearners', 15);
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    properties
        abStruct;
    end
    
    methods
        
        function obj = Adaboost(varargin)
            obj = obj@LearningAlgorithm(varargin);
        end
        
        function initParameters(~, p)
            p.addParamValue('nLearners', 10, @(x) assert(isnatural(x, true), 'Number of learners for Adaboost must be an integer > 0'));
        end
        
        function obj = train(obj, Xtr, Ytr)

            if(obj.getTask() == Tasks.BC)
                model = 'AdaBoostM1';
            elseif(obj.getTask() == Tasks.MC)
                model = 'AdaBoostM2';
            else
                model = 'LSBoost';
            end
    
            obj.abStruct = fitensemble(Xtr,Ytr,model,obj.trainingParams.nLearners, 'Tree');
            
        end
        
        function [labels, scores] = test(obj, Xts)
            
            labels = predict(obj.abStruct, Xts);
            scores = convert_scores(labels, obj.getTask());
             
        end
        
        function res = isTaskAllowed(~, ~)
            res = true;
        end
    end
    
    methods(Static)
        function info = getInfo()
            info = 'Adaboost learning algorithm (wrapper to the Adaboost of Matlab)';
        end
        
        function pNames = getParametersNames()
            pNames = {'nLearners'}; 
        end
        
        function pInfo = getParametersInfo()
            pInfo = {'Number of base learners to be trained'};
        end
        
        function pRange = getParametersRange()
            pRange = {'Integer > 0, default is 10'};
        end    
    end
    
end

