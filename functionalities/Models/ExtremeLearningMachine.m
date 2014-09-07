% ExtremeLearningMachine - Extreme Learning Machine model
%   For information, see:
%
%   [1] Huang, Guang-Bin, et al. 'Extreme learning machine for
%   regression and multiclass classification.'' Systems, Man, and
%   Cybernetics, Part B: Cybernetics, IEEE Transactions on 42.2 (2012):
%   513-529.
%
%   All parameters are name/value:
%
%   add_algorithm('ELM', 'ELM', @ExtremeLearningMachine, 'hiddenNodes',
%   50) changes the default number of nodes in the hidden layer.
%
%   add_algorithm('ELM', 'ELM', @ExtremeLearningMachine, 'type', 'rbf')
%   change the hidden activation functions
%
%   Default training algorithm is RegularizedELM.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef ExtremeLearningMachine < Model
    
    properties
        
        % Weights connecting to the hidden layer
        weights_l1;
        
        % Biases of the hidden layer
        bias_l1;
        
        % Weights connecting to the hidden layer
        outputWeights;
        
    end
    
    methods
        
        function obj = ExtremeLearningMachine(id, name, varargin)
            obj = obj@Model(id, name, varargin{:});
            obj.weights_l1 = [];
            obj.bias_l1 = [];
        end
        
        function a = getDefaultTrainingAlgorithm(obj)
            a = RegularizedELM(obj);
        end
        
        function p = initParameters(obj, p)
            p.addParamValue('hiddenNodes', 100, @(x) assert(isnatural(x, false), 'Hidden nodes of ExtremeLearningMachine must be an integer > 0'));
            p.addParamValue('type', 'sigmoid', @(x) assert(isingroup(x, {'sigmoid', 'sinusoid', 'hardlimit'}), 'Hidden nodes type of ExtremeLearningMachine is invalid'));
        end
        
        function [labels, scores] = test(obj, Xts)
            
            H_temp_test = obj.computeHiddenMatrix(Xts);
            scores =(H_temp_test * obj.outputWeights);
            labels = convert_scores(scores, obj.getCurrentTask());
            
        end
        
        function res = isDatasetAllowed(~, d)
            res = d.task == Tasks.R || d.task == Tasks.BC || d.task == Tasks.MC;
            res = res && d.X.id == DataTypes.REAL_MATRIX;
        end
        
        function obj = generateWeights(obj, d)
            % Generate randomly the weights
            if(isempty(obj.weights_l1))
                N_hidden = obj.parameters.hiddenNodes;
                obj.weights_l1 = rand(N_hidden, d)*2-1;
                obj.bias_l1 = rand(N_hidden,1)*2-1;
            end
        end
        
        function H = computeHiddenMatrix(obj, X)
            % Compute the hidden matrix
            H = obj.weights_l1*X';
            H = bsxfun(@plus, H, obj.bias_l1);
            H = obj.activationFunction(H);
            H = H';
        end
        
        function H = activationFunction(obj, H)
            % Compute activation function
            switch lower(obj.parameters.type)
                case {'sig','sigmoid'}
                    H = 1 ./ (1 + exp(-H));
                case {'sin','sinuisoid'}
                    H = sin(H);
                case {'hardlimit'}
                    H = double(hardlim(H));
                    
            end
        end
    end
    
    methods(Static)
        
        function info = getDescription()
            info = ['Extreme Learning Machine, for more information, ' ...
                'please refer to the following paper: Huang, Guang-Bin, et al. ''Extreme learning machine for regression and multiclass classification.'' Systems, Man, and Cybernetics, Part B: Cybernetics, IEEE Transactions on 42.2 (2012): 513-529.'];
        end
        
        function pNames = getParametersNames()
            pNames = {'hiddenNodes', 'type'};
        end
        
        function pInfo = getParametersDescription()
            pInfo = {'Number of hidden nodes', 'Family of hidden nodes'};
        end
        
        function pRange = getParametersRange()
            pRange = {'Integer > 0, default is 50', 'String in {sigmoid, sinuisoid, hardlimit}, default is sigmoid'};
        end
    end
    
end

