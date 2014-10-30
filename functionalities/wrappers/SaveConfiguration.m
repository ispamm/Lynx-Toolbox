% SaveConfiguration - Save the configurations of an algorithm
%   One file is created for each combination dataset/fold/run. See the help
%   for LoadConfiguration.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef SaveConfiguration < Wrapper
    
    properties
    end
    
    methods
        
        function obj = SaveConfiguration(wrappedAlgo, varargin)
            obj = obj@Wrapper(wrappedAlgo, varargin{:});
            obj.parameters.dest_folder = fullfile(XmlConfiguration.readConfigValue('root_folder'), obj.parameters.dest_folder);
        end
        
        function p = initParameters(~, p)
            p.addRequired('source_id'); 
            p.addParamValue('dest_folder', 'models/'); 
        end
        
        function obj = train(obj, d)
            obj.wrappedAlgo = obj.wrappedAlgo.train(d);
            model = obj.wrappedAlgo;
            
            if(~exist(obj.parameters.dest_folder, 'dir'))
                mkdir(obj.parameters.dest_folder);
                warning('Lynx:FileSystem:FolderNotExisting', 'The folder %s does not exists, it will be created', obj.parameters.dest_folder);
            end
            
            if(SimulationLogger.getInstance().flags.debug)
                fprintf('\t\t Saving configuration...\n');
            end
            save(sprintf('%s/%s_%s_r%df%d.mat',obj.parameters.dest_folder, obj.parameters.source_id, ... 
                SimulationLogger.getInstance().getAdditionalParameter('dataset_name'), ...
                SimulationLogger.getInstance().getAdditionalParameter('run'), ...
                SimulationLogger.getInstance().getAdditionalParameter('fold')), 'model');
        end
    
    end
    
    methods(Static)
        function info = getDescription()
            info = 'Save the configuration of an algorithm';
        end
        
        function pNames = getParametersNames()
            pNames = {'source_id', 'dest_folder'}; 
        end
        
        function pInfo = getParametersDescription()
            pInfo = {'Name of the model to save', 'Destination folder'};
        end
        
        function pRange = getParametersRange()
            pRange = {'String (required)', 'String, default to ''./models/'''};
        end 
    end
    
end