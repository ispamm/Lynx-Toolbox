classdef OneVersusAll < Wrapper
    % ONEVERSUSALL Performs a one-versus-all training for multi-class
    % tasks. Does nothing on other tasks. This has no parameters.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    properties
        models;
    end
    
    methods
        
        function obj = OneVersusAll(wrappedAlgo, varargin)
            obj = obj@Wrapper(wrappedAlgo, varargin);
            if(~obj.wrappedAlgo.isTaskAllowed(Tasks.BC))
                error('LearnToolbox:Logic:UnsupportedAlgorithm', 'OneVersusAll requires a base algorithm supporting binary classification');
            end
        end
        
        function initParameters(~, p)
        end
        
        function obj = train(obj, Xtr, Ytr)
            
            if(~(obj.getTask() == Tasks.MC))
                
                obj.wrappedAlgo = obj.wrappedAlgo.setTask(obj.getTask());
                obj.wrappedAlgo = obj.wrappedAlgo.train(Xtr, Ytr);
                
            else
                
                nClasses = max(Ytr);
                obj.models = cell(1, nClasses);
            
                obj.wrappedAlgo = obj.wrappedAlgo.setTask(Tasks.BC);
                
                for i = 1:nClasses
                   
                    Y = zeros(size(Ytr,1), 1);
                    Y(Ytr == i) = 1;
                    Y(Ytr ~= i) = -1;
                    
                    obj.models{i} = obj.wrappedAlgo.train(Xtr, Y);
                    
                end
                
            end
            
        end
    
        function [labels, scores] = test(obj, Xts)
            if(obj.getTask() ~= Tasks.MC)
                [labels, scores] = obj.wrappedAlgo.test(Xts);
            else
                scores = zeros(size(Xts,1), length(obj.models));
                
                for i=1:length(obj.models)
                    [~, scores(:,i)] = obj.models{i}.test(Xts);
                end
                
                labels = convert_scores(scores, Tasks.MC);
            end
        end
        
        function res = isTaskAllowed(obj, task)
           res = (task == Tasks.MC) || obj.wrappedAlgo.isTaskAllowed(task); 
        end
    end
    
    methods(Static)
        function info = getInfo()
            info = 'Performs a One-Versus-All Strategy for MultiClass Classification';
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