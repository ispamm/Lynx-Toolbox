classdef LearningAlgorithm
    % LearningAlgorithm An abstract class for creating supervised learning
    % algorithms. Any class extending LearningAlgorithm can be used to 
    % build a model for supervised learning and test it on unseen data.
    %
    % LearningAlgorithm Properties:
    %
    %   trainingParams - A struct containing all the parameters needed for
    %   training the model. This parameters are passed through its
    %   constructor and can be modified afterwards.
    %
    %   statistics - A struct containing all the resulting statistics
    %   of the training procedure.
    %
    % LearningAlgorithm Methods:
    %
    %   train - Takes an Nxd input matrix Xtr, and associated labels Ytr, 
    %   and trains its internal model.
    %
    %   test - Takes an Mxd input matrix Xts, and returns the labels (and
    %   confidence scores) computed on each of the M samples. If the
    %   algorithm or the task do not admit confidence scores, the scores
    %   are set equal to the labels.
    %
    %   isTaskAllowed - Returns a boolean indicating whether a given task 
    %   is allowed
    %
    %   getInfo - Returns a string describing the algorithm
    %
    %   getParametersNames - Returns a cell array with the name of each
    %   training parameter
    %
    %   getParametersInfo - Returns a cell array of strings describing each
    %   training parameter
    %
    %   setTask - Set the current task
    %
    %   getTask - Returns the current task
    %
    %   getTrainingParam - Return a parameter used for training
    %
    %   setTrainingParam - Set a parameter used for training
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
    
    
    properties
        trainingParams; % Training parameters
        statistics;     % Statistics of training            
    end
    
    methods(Abstract=true)
        
        initParameters(obj, p);             % Initialize the training parameters
        obj = train(obj, Xtr, Ytr)          % Train the model
        [labels, scores] = test(obj, Xts)   % Test the model
        res = isTaskAllowed(obj, task)      % Check if a task is allowed
    
    end
    
    methods(Abstract,Static)
        
        info = getInfo()                % Get information on the algorithm
        pNames = getParametersNames()   % Get the name of the parameters
        pInfo = getParametersInfo()     % Get info on the parameters
        pRange = getParametersRange()   % Get info on the possible values of the parameters
        
    end
    
    methods
        
        function obj = LearningAlgorithm(varargin)
            p = inputParser;
            initParameters(obj, p);
            if(~isempty(varargin{:}))
                p.parse(varargin{:}{:}{:});
                obj.trainingParams = p.Results;
            end
            obj.statistics = struct();
        end
        
        function obj = setTask(obj, t)
            % Set the current task
            obj.trainingParams.task = t; 
        end
        
        function t = getTask(obj)
            % Get the current task
            t = obj.trainingParams.task;
        end
        
        function value = getTrainingParam(obj, param)
            % Get the value of a training parameter
           if(isfield(obj.trainingParams, param))
               value = obj.trainingParams.(param);
           else
               error('LearnToolbox:Validation:WrongInput', 'The training parameter %s does not exists', param);
           end
        end
        
        function obj = setTrainingParam(obj, param, value)
            % Set the value of a training parameter
           if(isfield(obj.trainingParams, param))
               obj.trainingParams.(param) = value;
           else
               error('LearnToolbox:Validation:WrongInput', 'The training parameter %s does not exists', param);
           end
        end
        
        function stat = getStatistics(obj)
            % Get the statistics struct
            stat = obj.statistics;
        end
        
        function tp = getTrainingParams(obj)
            % Get the training parameters struct
            tp = obj.trainingParams;
        end
        
        function b = isOfClass(obj, c)
            % Check if the algorithm is of a given class
            b = isa(obj, c);
        end
        
    end
    
end

