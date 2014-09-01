% LoadConfiguration - Loads the configuration of a model
%   This suppose that a configuration has been previously saved using
%   the SaveConfiguration wrapper. Suppose you have saved the
%   parameters of a MultilayerPerceptron in a previous run:
%
%   add_wrapper('MLP', @SaveConfiguration, 'MLP_saved');
%
% In a successive run, these can be loaded by calling:
%
%   add_wrapper('MLP', @LoadConfiguration, 'MLP_saved');
%
% You can specify a folder for loading:
%
%   add_wrapper('MLP', @SaveConfiguration, 'MLP_saved', 'folder', 'custom_folder');
%
% You can load only a specified subset of training parameters:
%
%   add_wrapper('MLP', @SaveConfiguration, 'MLP_saved', 'params_to_load', {'hiddenNodes'});

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef LoadConfiguration < Wrapper
    
    properties
    end
    
    methods
        
        function obj = LoadConfiguration(wrappedAlgo, varargin)
            obj = obj@Wrapper(wrappedAlgo, varargin{:});
            obj.parameters.source_folder = fullfile(XmlConfiguration.readConfigValue('root_folder'), obj.parameters.source_folder);
        end
        
        function p = initParameters(~, p)
            p.addRequired('source_id');
            p.addParamValue('source_folder', 'models/');
            p.addParamValue('params_to_load', []);
        end
        
        function obj = train(obj, Xtr, Ytr)
            
            log = SimulationLogger.getInstance();
            fileName = sprintf('%s/%s_%s_r%df%d.mat',obj.parameters.source_folder, obj.parameters.source_id, ...
                log.getAdditionalParameter('dataset_name'), ...
                log.getAdditionalParameter('run'), ...
                log.getAdditionalParameter('fold'));
            
            if(log.flags.debug)
                fprintf('\t\t Loading parameters: ');
            end
            
            if(exist(fileName, 'file'))
                o = load(fileName);
                
                if(isempty(obj.parameters.params_to_load))
                    params = fields(o.getParameters());
                else
                    params = obj.parameters.params_to_load;
                end
                
                for i=1:length(params)
                    obj.wrappedAlgo = obj.wrappedAlgo.setParameter(params{i}, o.model.getParameter(params{i}));
                    if(log.flags.debug)
                        fprintf('%s = %f', params{i}, o.model.getParameter(params{i}));
                        if(~ (i==length(params)))
                            fprintf(', ');
                        end
                    end
                end
                if(log.flags.debug)
                    fprintf('\n');
                end
            end
            
            obj.wrappedAlgo = obj.wrappedAlgo.train(Xtr, Ytr);
        end
        
    end
    
    methods(Static)
        function info = getDescription()
            info = 'Wrapper to load the configuration of an algorithm';
        end
        
        function pNames = getParametersNames()
            pNames = {'source_id', 'source_folder', 'params_to_load'};
        end
        
        function pInfo = getParametersDescription()
            pInfo = {'Name of the model to read from', 'Source folder', 'Parameters to read from the model'};
        end
        
        function pRange = getParametersRange()
            pRange = {'String (required)', 'String','Cell array of strings (default to all parameters)'};
        end
    end
    
end