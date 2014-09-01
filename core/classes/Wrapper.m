% Wrapper - An abstract class for creating a wrapper to a supervised learning algorithm
%   The wrapper encapsulates the algorithm to provide
%   additional functionalities.
%
% Wrapper Properties
%
%   wrappedAlgo - The encapsulated LearningAlgorithm
%
% Wrapper Methods
%
%   Wrapper - Constructs a new Wrapper by providing the base
%   LearningAlgorithm
%
%   isTaskAllowed - Specifies whether a given task is allowed or not,
%   depending on the Wrapper and on its base LearningAlgorithm
%
%   getStatistics - Get the structure resulting from the concatenation
%   of the statistics of all internal learning algorithms.
%
%   isOfClass - A boolean indicating whether the wrapper or one of its
%   base learning algorithms are of a given class.
%
% See also LearningAlgorithm

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef Wrapper <  LearningAlgorithm
    
    properties
        wrappedAlgo; % Wrapped LearningAlgorithm
    end
    
    methods
        function obj = Wrapper(wrappedAlgo, varargin)
            obj = obj@LearningAlgorithm([], varargin{:});
            obj.wrappedAlgo = wrappedAlgo;
        end
        
        function [labels, scores] = test(obj, Xts)
            if(obj.hasCustomTesting())
                [labels, scores] = obj.test_custom(Xts);
            else
                [labels, scores] = obj.wrappedAlgo.test(Xts);
            end
        end
        
        function res = isTaskAllowed(obj, task)
            res = obj.wrappedAlgo.isTaskAllowed(task);
        end
        
        function value = getParameter(obj, param)
            if(isfield(obj.parameters, param))
                value = obj.parameters.(param);
            else
                value = obj.wrappedAlgo.getParameter(param);
            end
        end
        
        function obj = setParameter(obj, param, value)
            if(isfield(obj.parameters, param))
                obj.parameters.(param) = value;
            else
                obj.wrappedAlgo = obj.wrappedAlgo.setParameter(param, value);
            end
        end
        
        function stat = getStatistics(obj)
            stat = catstruct(obj.statistics, obj.wrappedAlgo.getStatistics());
        end
        
        function tp = getParameters(obj)
            warning('off', 'catstruct:DuplicatesFound');
            tp = catstruct(obj.parameters, obj.wrappedAlgo.getParameters());
        end
        
        function b = isOfClass(obj, c)
            b = isa(obj, c) || obj.wrappedAlgo.isOfClass(c);
        end
        
        function b = checkForCompatibility(obj, model)
            b = obj.wrappedAlgo.checkForCompatibility(model);
        end
        
        function b = checkForPrerequisites(obj)
            b = obj.wrappedAlgo.checkForPrerequisites();
        end
        
        function obj = setCurrentTask(obj, t)
            % Set the current task
            obj.task = t;
            obj.wrappedAlgo = obj.wrappedAlgo.setCurrentTask(t);
        end
        
        function varargout = subsref(A, S)
            % Return the id and name of the internal model
            if(strcmp(S(1).type, '.') && isingroup(S(1).subs, {'id', 'name'}))
                varargout{1} = subsref(A.wrappedAlgo, S);
            else
                [varargout{1:nargout}] = builtin('subsref', A, S);
            end
        end
        
        function s = getInstanceDescription_recursive(obj, s)
            s = obj.wrappedAlgo.getInstanceDescription_recursive(s);
            if(~obj.wrappedAlgo.isOfClass('Wrapper'))
                s = sprintf('%s, wrappers: %s', s, class(obj));
            else
                s = sprintf('%s, %s', s, class(obj));
            end
        end
        
    end
    
end

