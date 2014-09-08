% MultilayerPerceptron - Multilayer perceptron with 1 hidden layer
%   This is a three layered artificial neural network, with 1 input layer,
%   1 hidden layer, and 1 output layer.
%
%   The only training parameter is the number of nodes in the hidden
%   layer:
%
%   add_model('NN', 'NNet', @MultilayerPerceptron, 'hiddenNodes',
%   15).

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef MultilayerPerceptron < Model
    
    properties
        % TODO
    end
    
    methods
        
        function obj = MultilayerPerceptron(id, name, varargin)
            obj = obj@Model(id, name, varargin{:});
        end
        
        function p = initParameters(~, p)
            p.addParamValue('hiddenNodes', 10, @(x) assert(mod(x,1) == 0 && x > 0, 'Number of hidden nodes of MLP must be > 0'));
        end
        
        function [labels, scores] = test(obj, d)
            % TODO
        end
        
        function a = getDefaultTrainingAlgorithm(obj)
            a = MatlabMLP(obj);
        end
        
        function res = isDatasetAllowed(~, d)
            res = d.task == Tasks.R || d.task == Tasks.BC || d.task == Tasks.MC;
            res = res && d.X.id == DataTypes.REAL_MATRIX;
        end
    end
    
    methods(Static)
        function info = getDescription()
            info = 'Multilayer Perceptron with three hidden layers';
        end
        
        function pNames = getParametersNames()
            pNames = {'hiddenNodes'}; 
        end
        
        function pInfo = getParametersDescription()
            pInfo = {'Number of nodes in hidden layer'};
        end
        
        function pRange = getParametersRange()
            pRange = {'Positive integer, default is 10'};
        end 
    end
    
end

