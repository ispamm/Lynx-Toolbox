% OneVersusAll - Perform a one-versus-all training for multi-class tasks
%   Does nothing on other tasks. This has no parameters.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef OneVersusAll < Wrapper
    
    properties
        models;
    end
    
    methods
        
        function obj = OneVersusAll(wrappedAlgo, varargin)
            obj = obj@Wrapper(wrappedAlgo, varargin{:});
            if(~obj.wrappedAlgo.isDatasetAllowed(Dataset(RealMatrix([]), [], Tasks.BC)))
                error('Lynx:Runtime:UnsupportedAlgorithm', 'OneVersusAll requires a base algorithm supporting binary classification');
            end
        end
        
        function p = initParameters(~, p)
        end
        
        function obj = train(obj, d)
            
            if(~(d.task == Tasks.MC))
                
                obj.wrappedAlgo = obj.wrappedAlgo.train(d);
                
            else
                
                Ytr = d.Y.data;
                nClasses = max(Ytr);
                obj.models = cell(1, nClasses);
    
                d.task = Tasks.BC;
                
                for i = 1:nClasses
                   
                    d.Y.data = zeros(size(Ytr,1), 1);
                    d.Y.data(Ytr == i) = 1;
                    d.Y.data(Ytr ~= i) = -1;
                    
                    obj.models{i} = obj.wrappedAlgo.train(d);
                    
                end
                
            end
            
        end
    
        function b = hasCustomTesting(obj)
            b = true;
        end
        
        function [labels, scores] = test_custom(obj, d)
            if(d.task ~= Tasks.MC)
                [labels, scores] = obj.wrappedAlgo.test(d);
            else
                scores = zeros(size(d.X.data,1), length(obj.models));
                d.task = Tasks.BC;
                for i=1:length(obj.models)
                    [~, scores(:,i)] = obj.models{i}.test(d);
                end
                
                labels = convert_scores(scores, Tasks.MC);
            end
        end
        
        function res = isDatasetAllowed(obj, d)
           res = (d.task == Tasks.MC) || obj.wrappedAlgo.isDatasetAllowed(d); 
        end
    end
    
    methods(Static)
        function info = getDescription()
            info = 'Performs a One-Versus-All Strategy for MultiClass Classification';
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