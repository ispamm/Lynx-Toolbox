% BaselineModel - Baseline model for comparing performances
%   A BaselineModel is a model with no parameters that can be used to 
%   compare performances with respect to the simplest possible baseline.
%
%   - For regression, BaselineModel always output the mean value of the
%   output elements in the training set.
%   - For classification, BaselineModel outputs random labels, in the same
%   proportion with respect to the training set.
%
%   BaselineModel has a single associated TrainingAlgorithm which should
%   not be changed.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it


classdef BaselineModel < Model
    
    properties
        avValue;        % Mean value for regression
        distribution;   % Output distribution for classification
        values;         % Classes
    end
    
    methods
        
        function obj = BaselineModel(id, name, varargin)
            obj = obj@Model(id, name, varargin{:});
        end
        
        function a = getDefaultTrainingAlgorithm(obj)
            a = BaselineTrainingAlgorithm(obj);
        end
        
        function p = initParameters(~, p)
        end
        
        function [labels, scores] = test(obj, d)
            
            % Get training data
            Xts = d.X.data;
            
            if(d.task == Tasks.R)
                % In case of regression, always return the mean value of
                % the training set
                labels = obj.avValue*ones(size(Xts, 1), 1);
                scores = labels;
            else
                % In case of classification, sample with respect to the
                % distribution of the training data
                samp = discretesample(obj.distribution, size(Xts, 1))';
                labels = (obj.values(samp))';
                if(size(labels, 1) == 1)
                    labels = labels';
                end
                scores = labels;
            end
            
        end
        
        function res = isDatasetAllowed(~, d)
            res = d.task == Tasks.R || d.task == Tasks.BC || d.task == Tasks.MC;
            res = res && d.X.id == DataTypes.REAL_MATRIX;
        end
    end
    
    methods(Static)
        function info = getDescription()
            info = 'Dummy model, should be used only as a baseline for error rates.';
        end
        
    end
    
end

