    
classdef KNearestNeighbour < LearningAlgorithm
    % KNEARESTNEIGHBOUR This implements the standard KNN learning method.
    % This uses the KNN defined in the Statistics Toolbox of Matlab.
    %
    % All parameters are name/value:
    %
    %   K - Number of neighbours to consider
    %   distance - Distance function to be used. It is a string identifying
    %   a distance metric inside Matlab.
    %   weights - String or function specifying the distance weighting
    %   function.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    properties
        knnStruct;
    end
    
    methods
        
        function obj = KNearestNeighbour(varargin)
            obj = obj@LearningAlgorithm(varargin);
        end
        
        function initParameters(~, p)
            p.addParamValue('K', 3, @(x) assert(mod(x,1) == 0 && x > 0, 'K must be an integer > 0'));
            p.addParamValue('distance', 'euclidean');
        end
        
        function obj = train(obj, Xtr, Ytr)

            obj.knnStruct = ClassificationKNN.fit(Xtr,Ytr, 'NumNeighbors', obj.trainingParams.K, ...
                'Distance', obj.trainingParams.distance);
                        
        end
        
        function [labels, scores] = test(obj, Xts)
            
             labels = predict(obj.knnStruct,Xts);
             scores = labels;
             
        end
        
        function res = isTaskAllowed(~, ~)
            res = true;
        end
    
    end
    
    methods(Static)
        
        function info = getInfo()
            info = ['This is a wrapper to the K-Nearest Neighbours classifier included in the Statistics Toolbox of Matlab.', ...
                'For additional information, call ''doc ClassificationKNN''.'];
        end
        
        function pNames = getParametersNames()
            pNames = {'K', 'distance'}; 
        end
        
        function pInfo = getParametersInfo()
            pInfo = {'K to be used in K-NN', 'Distance function'};
        end
        
        function pRange = getParametersRange()
            pRange = {'Positive integer, default  is3', 'See help ClassificationKNN.fit, default is ''euclidean'''};
        end 
        
    end
    
end

