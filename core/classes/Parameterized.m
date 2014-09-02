% Parameterized - A class with parameters that can be initialized during construction
%   A PARAMETERIZED class contains a struct of parameters which are
%   initialized during construction. Moreover, it has a set of utility
%   methods for describing the parameters name and possible values. See
%   any class extending Model, LearningAlgorithm, Wrapper,
%   PerformanceMeasure for practical implementations.
%
% See also: InputParser

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef Parameterized
    
    properties
        
        % Parameters
        parameters;
        
    end
    
    methods(Abstract=true)
        
        % Initialize the InputParser object
        p = initParameters(obj, p);
        
    end
    
    methods(Abstract,Static)
        
        % Get information on the method
        info = getDescription();
        
    end
    
    methods(Static)
        
        function pNames = getParametersNames()
            % Get the name of the parameters
            pNames = {};
        end
        
        function pInfo = getParametersDescription()
            % Get info on the parameters
            pInfo = {};
        end
        
        function pRange = getParametersRange()
            % Get info on the possible values of the parameters
            pRange = {};
        end
        
    end
    
    methods
        
        function obj = Parameterized(varargin)
            % Construct the method and initialize its parameters
            
            % Initialize the parameters
            p = inputParser;
            p = obj.initParameters(p);
            
            try
                p.parse(varargin{:});
            catch err
                error('Lynx:Initialization:Parameters', 'Please ensure that the initialization parameters for object of type %s are valid', class(obj));
            end
            obj.parameters = p.Results;
            
        end
        
        function value = getParameter(obj, param)
            % Return the value of a parameter
            
            if(isfield(obj.parameters, param))
                value = obj.parameters.(param);
            else
                error('Lynx:Runtime:ParameterNotExisting', 'The parameter %s does not exists', param);
            end
        end
        
        function obj = setParameter(obj, param, value)
            % Set the value of a parameter
            
            if(isfield(obj.parameters, param))
                obj.parameters.(param) = value;
            else
                error('Lynx:Runtime:ParameterNotExisting', 'The parameter %s does not exists', param);
            end
        end
        
        function tp = getParameters(obj)
            % Get the struct with parameters of model and training
            % algorithm
            tp = obj.parameters;
        end
        
    end
    
end

