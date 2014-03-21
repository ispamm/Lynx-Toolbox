classdef LoadConfiguration < Wrapper
    % LOADCONFIGURATION Loads the configuration of a model, which has been
    % previously saved using the SaveConfiguration wrapper. Suppose you
    % have saved the parameters of a MultilayerPerceptron in a previous
    % run:
    %
    %   add_wrapper('MLP', @SaveConfiguration, 'MLP_saved', './models/');
    %
    % In a successive run, these can be loaded by calling:
    %
    %   add_wrapper('MLP', @LoadConfiguration, './models/', 'MLP_saved',
    %   {'hiddenNodes'});
    %
    % Note that the training parameters to load have to be explicitly
    % stated.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    properties
    end
    
    methods
        
        function obj = LoadConfiguration(wrappedAlgo, varargin)
            obj = obj@Wrapper(wrappedAlgo, varargin);
        end
        
        function initParameters(~, p)
            p.addRequired('source_folder');
            p.addRequired('source_id');
            p.addRequired('params_source');
            p.addOptional('params_dest', []);
        end
        
        function obj = train(obj, Xtr, Ytr)
            if(isempty(obj.trainingParams.params_dest))
                obj.trainingParams.params_dest = obj.trainingParams.params_source;
            end
            log = Logger.getInstance();
            fileName = sprintf('%s/%s_%s_%d.mat',obj.trainingParams.source_folder, obj.trainingParams.source_id, ... 
                SimulationLogger.getInstance().getOptionalParameter('dataset_name'), ...
                SimulationLogger.getInstance().getOptionalParameter('fold'));
            sprintf(obj.trainingParams.source_file, log.getParameter('fold'));
            if(exist(fileName, 'file'))
                model = load(fileName);
                for i=1:length(obj.trainingParams.params)
                   obj.wrappedAlgo = obj.wrappedAlgo.setTrainingParam(obj.trainingParams.params_dest{i}, model.model.getTrainingParam(obj.trainingParams.params{i}));
                end
            end
            obj.wrappedAlgo = obj.wrappedAlgo.setTask(obj.getTask());
            obj.wrappedAlgo = obj.wrappedAlgo.train(Xtr, Ytr);
        end
    
        function [labels, scores] = test(obj, Xts)
            [labels, scores] = obj.wrappedAlgo.test(Xts);
        end
        
        function res = isTaskAllowed(obj, task)
           res = obj.wrappedAlgo.isTaskAllowed(task); 
        end
    end
    
    methods(Static)
        function info = getInfo()
            info = 'Wrapper to load the configuration of an algorithm';
        end
        
        function pNames = getParametersNames()
            pNames = {'source_folder', 'source_id', 'params_source', 'params_dest'}; 
        end
        
        function pInfo = getParametersInfo()
            pInfo = {'Source folder', 'Name of the model to read from', 'Parameters to read from the model', ...
                'Parameters to change in the internal algorithm'};
        end
        
        function pRange = getParametersRange()
            pRange = {'String (required)', 'String (required)','Cell array of strings (required)','Cell array of strings (optional, defaults to params_source)'};
        end 
    end
    
end