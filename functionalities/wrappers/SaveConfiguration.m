classdef SaveConfiguration < Wrapper
    % SAVECONFIGURATION Save the configurations of an algorithm after
    % training in a specified folder. One file is created for each
    % combination dataset/fold/run.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    properties
    end
    
    methods
        
        function obj = SaveConfiguration(wrappedAlgo, varargin)
            obj = obj@Wrapper(wrappedAlgo, varargin);
        end
        
        function initParameters(~, p)
            p.addRequired('source_id'); 
            p.addParamValue('dest_folder', './tmp/'); 
        end
        
        function obj = train(obj, Xtr, Ytr)
            obj.wrappedAlgo = obj.wrappedAlgo.setTask(obj.getTask());
            obj.wrappedAlgo = obj.wrappedAlgo.train(Xtr, Ytr);
            model = obj.wrappedAlgo;
            
            if(~exist(obj.trainingParams.dest_folder, 'dir'))
                mkdir(obj.trainingParams.dest_folder);
                warning('LearnToolbox:FileSystem:FolderNotExisting', 'The folder %s does not exists, it will be created', obj.trainingParams.dest_folder);
            end
            
            if(SimulationLogger.getInstance().flags.debug)
                fprintf('\t\t Saving configuration...\n');
            end
            save(sprintf('%s/%s_%s_r%df%d.mat',obj.trainingParams.dest_folder, obj.trainingParams.source_id, ... 
                SimulationLogger.getInstance().getAdditionalParameter('dataset_name'), ...
                SimulationLogger.getInstance().getAdditionalParameter('run'), ...
                SimulationLogger.getInstance().getAdditionalParameter('fold')), 'model');
            
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
            info = 'Save the configuration of an algorithm';
        end
        
        function pNames = getParametersNames()
            pNames = {'source_id', 'dest_folder'}; 
        end
        
        function pInfo = getParametersInfo()
            pInfo = {'Name of the model to save', 'Destination folder'};
        end
        
        function pRange = getParametersRange()
            pRange = {'String (required)', 'String, default to ''./tmp/'''};
        end 
    end
    
end