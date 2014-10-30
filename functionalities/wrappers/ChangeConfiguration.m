% ChangeConfiguration - This wrapper changes the configuration of an
% algorithm on a specified dataset. Suppose you have a
% MultilayerPerceptron with 15 hidden nodes added to the simulation,
% and two datasets A and B. The following call will make the MLP use 20
% hidden nodes when executing on dataset B:
%
%   add_wrapper('MLP', @ChangeConfiguration, 'B', {'hiddenNodes'},
%   {20});

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef ChangeConfiguration < Wrapper
    
    properties
        % The alternative model to be used
        alternativeModel;
    end
    
    methods
        
        function obj = ChangeConfiguration(wrappedAlgo, varargin)
            obj = obj@Wrapper(wrappedAlgo, varargin{:});
        end
        
        function p = initParameters(~, p)
            p.addRequired('dataset_id');
            p.addRequired('params_names');
            p.addRequired('new_params_values');
        end
        
        function obj = train(obj, d)
            if(strcmp(d.id, obj.parameters.dataset_id))
                obj.alternativeModel = obj.wrappedAlgo;
                for i=1:length(obj.parameters.params_names)
                   obj.alternativeModel = obj.alternativeModel.setParameter(obj.parameters.params_names{i}, ...
                       obj.parameters.new_params_values{i});
                end
                obj.alternativeModel = obj.alternativeModel.train(d);
            else
                obj.wrappedAlgo = obj.wrappedAlgo.train(d);
            end
        end
    
        function b = hasCustomTesting(obj)
            b = true;
        end
        
        function [labels, scores] = test_custom(obj, d)
            if(strcmp(d.id, obj.parameters.dataset_id))
                [labels, scores] = obj.alternativeModel.test(d);
            else
                [labels, scores] = obj.wrappedAlgo.test(d);
            end
        end
        
    end
    
    methods(Static)
        function info = getDescription()
            info = 'Change the configuration of an algorithm on a specified dataset';
        end
        
        function pNames = getParametersNames()
            pNames = {'dataset_id', 'params_names', 'new_params_values'}; 
        end
        
        function pInfo = getParametersDescription()
            pInfo = {'Name of the dataset', 'Training parameter names', 'Alternative values'};
        end
        
        function pRange = getParametersRange()
            pRange = {'String (required)', 'Nx1 cell array (required)', 'Nx1 cell array (required)'};
        end 
    end
    
end