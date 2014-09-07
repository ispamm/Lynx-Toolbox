% LearningAlgorithm - Training algorithm
%   An abstract class for creating supervised learning
%   algorithms. Any class extending LearningAlgorithm can be used to
%   build a model for supervised learning and test it on unseen data.
%
% LearningAlgorithm Properties:
%
%   model - The model to train
%
%   statistics - A struct containing all the resulting statistics
%   of the training procedure.
%
% LearningAlgorithm Methods:
%
%   train - Takes an Nxd input matrix Xtr, and associated labels Ytr,
%   and trains its internal model.
%
%   test_custom - An optional testing procedure
%
%   isTaskAllowed - Returns a boolean indicating whether a given task
%   is allowed
%
%   setTask - Set the current task
%
%   getTask - Returns the current task
%
%   getParameter - Return a parameter used for training or internal
%   of the model
%
%   setParameter - Set a parameter used for training or internal of
%   the model
%
%   getParameters - Return the union of the parameters of the training
%   algorithm and of the model
%
%   getStatistics - Return the statistics structure
%
%   isOfClass - Check whether the learning algorithm is of a given
%   class

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef LearningAlgorithm < Parameterized
    
    properties
        
        % Model
        model;
        
        % Statistics of training
        statistics;
        
        % Current task
        task;
        
    end
    
    methods(Abstract=true)
        
        % Train the model
        obj = train(obj, Xtr, Ytr)
        
        % Check for compatibility
        b = checkForCompatibility(obj, model);
        
    end
    
    methods
        
        function obj = LearningAlgorithm(model, varargin)
            obj = obj@Parameterized(varargin{:});
            obj.statistics = struct();
            obj.model = model;
            if(~isempty(model))
                b = obj.checkForCompatibility(model);
                if(~b)
                    error('Lynx:Runtime:ModelNotCompatible', 'Model of class %s is incompatible with training algorithm %s', class(model), class(obj));
                end
            end
        end
        
        function res = checkForPrerequisites(obj)
            % Check for prerequisites
            res = true;
        end
        
        function b = hasCustomTesting(obj)
            % Verify if this has a custom testing procedure
            b = false;
        end
        
        function b = hasGPUSupport(obj)
            b = false;
        end
        
        function [labels, scores] = test_custom(obj, Xts)
            % Test the model with a custom testing procedure
            error('Lynx:Runtime:MethodNotOverloaded', 'The training algorithm %s has no custom testing procedure', class(obj));
        end
        
        function [labels, scores] = test(obj, Xts)
            % Test using the training algorithm custom testing, if defined,
            % or the global one
            if(obj.hasCustomTesting())
                [labels, scores] = obj.test_custom(Xts);
            else
                [labels, scores] = obj.model.test(Xts);
            end
        end
        
        function obj = setCurrentTask(obj, t)
            % Set the current task
            obj.task = t;
            if(~isempty(obj.model))
                obj.model = obj.model.setCurrentTask(t);
            end
        end
        
        function t = getCurrentTask(obj)
            % Get the current task
            t = obj.task;
        end
        
        function value = getParameter(obj, param)
            % Get the value of a parameter
            try
                value = obj.getParameter@Parameterized(param);
            catch
                try
                    value = obj.model.getParameter(param);
                catch
                    error('Lynx:Runtime:ParameterNotExisting', 'The parameter %s in model %s does not exists', param, obj.model.name);
                end
            end
        end
        
        function obj = setParameter(obj, param, value)
            % Set the value of a parameter
            
            try
                obj.model = obj.model.setParameter(param, value);
            catch
                try
                    obj = obj.setParameter@Parameterized(param, value);
                catch
                    error('Lynx:Runtime:ParameterNotExisting', 'The training parameter %s in model %s does not exists', param, obj.model.name);
                end
            end
        end
        
        function res = isDatasetAllowed(obj, d)
            res = obj.model.isDatasetAllowed(d);
        end
        
        function stat = getStatistics(obj)
            % Get the statistics struct
            stat = obj.statistics;
        end
        
        function tp = getParameters(obj)
            % Get the training parameters struct
            if(~isempty(obj.model))
                tp = catstruct(obj.model.getParameters(), obj.parameters);
            else
                tp = obj.parameters;
            end
        end
        
        function b = isOfClass(obj, c)
            % Check if the algorithm is of a given class
            if(~isempty(obj.model))
                b = isa(obj, c) || obj.model.isOfClass(c);
            else
                b = isa(obj,c);
            end
        end
        
        function varargout = subsref(A, S)
            % Return the id and name of the internal model
            if(strcmp(S(1).type, '.') && isingroup(S(1).subs, {'id', 'name'}))
                varargout{1} = builtin('subsref', A.model, S);
            else
                [varargout{1:nargout}] = builtin('subsref', A, S);
            end
        end
        
        function s = getInstanceDescription(obj)
            s = getInstanceDescription_recursive(obj, '');
        end
        
        function s = getInstanceDescription_recursive(obj, ~)
            s = sprintf('%s, trained with %s', class(obj.model), class(obj));
        end
        
    end
    
end

