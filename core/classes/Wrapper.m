classdef Wrapper < LearningAlgorithm
    % Wrapper An abstract class for creating a wrapper to a supervised
    % learning algorithm. The wrapper encapsulates the algorithm to provide
    % additional functionalities.
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
    
    properties
        wrappedAlgo; % Wrapped LearningAlgorithm
    end
    
    methods
        function obj = Wrapper(wrappedAlgo, varargin)
           obj = obj@LearningAlgorithm(varargin);
           obj.wrappedAlgo = wrappedAlgo; 
           obj.verbose = true;
        end
        
        function res = isTaskAllowed(obj, task)
            res = obj.wrappedAlgo.isTaskAllowed(task);
        end
        
        function value = getTrainingParam(obj, param)
           if(isfield(obj.trainingParams, param))
               value = obj.trainingParams.(param);
           else
               value = obj.wrappedAlgo.getTrainingParam(param);
           end
        end
        
        function obj = setTrainingParam(obj, param, value)
           if(isfield(obj.trainingParams, param))
               obj.trainingParams.(param) = value;
           else
               obj.wrappedAlgo = obj.wrappedAlgo.setTrainingParam(param, value);
           end
        end
        
        function stat = getStatistics(obj)
            stat = catstruct(obj.statistics, obj.wrappedAlgo.getStatistics());
        end
        
        function tp = getTrainingParams(obj)
            warning('off', 'catstruct:DuplicatesFound');
            tp = catstruct(obj.trainingParams, obj.wrappedAlgo.getTrainingParams());
        end
        
        function b = isOfClass(obj, c)
            b = isa(obj, c) || obj.wrappedAlgo.isOfClass(c);
        end
        
    end
    
end

