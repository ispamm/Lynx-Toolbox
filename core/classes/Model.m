% Model - A possible model for a supervised learning task
%
% Model properties:
%
%   id - The id of the instantiated model
%
%   name - The name of the instantiated model
%
% Model methods:
%
%   initDefaultTrainingAlgorithm - Initialize a default training
%   algorithm
%
%   test - Takes a testing dataset, and returns the labels (and
%   confidence scores) computed on each of the M samples. If the
%   model or the task do not admit confidence scores, the scores
%   are set equal to the labels.
%
%   isDatasetAllowed - Returns a boolean indicating whether a given dataset
%   is allowed
%
%   isOfClass - Check whether the model is of a given class

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef Model < Parameterized
    
    properties
        
        % Id of the model;
        id;
        
        % Name of the model
        name;
        
    end
    
    methods(Abstract=true)
        
        % Initialize a default training algorithm
        a = getDefaultTrainingAlgorithm(obj);
        
        % Test the model
        [labels, scores] = test(obj, dataset);
        
        % Check if a dataset is allowed by the model
        res = isDatasetAllowed(obj, d);
        
    end
    
    methods
        
        function obj = Model(id, name, varargin)
            % Construct the model and initialize its parameters
            obj = obj@Parameterized(varargin{:});
            
            obj.id = id;
            obj.name = name;
        end
        
        function b = isOfClass(obj, c)
            % Check if the algorithm is of a given class
            b = isa(obj, c);
        end
        
    end
    
end

