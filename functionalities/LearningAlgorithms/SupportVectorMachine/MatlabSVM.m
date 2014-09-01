% MatlabSVM - A class wrapping the Support Vector Machine of Matlab

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef MatlabSVM < LearningAlgorithm
    
    properties
        svmStruct;
        Xtr;
    end
    
    methods
        
        function obj = MatlabSVM(model, varargin)
            obj = obj@LearningAlgorithm(model, varargin{:});
        end
        
        function p = initParameters(~, p)
        end
        
        function obj = train(obj, Xtr, Ytr)
            
            % Needed for custom kernel
            if(strcmp(obj.getParameter('kernel_type'), 'custom') && (any(isnan(Xtr(:))) || rcond(Xtr) < 10^-8))
                obj.svmStruct = [];
                return;
            end
            
            % Remove LibSVM from path for a naming conflict
            warning('off', 'MATLAB:rmpath:DirNotFound');
            rmpath(genpath(fullfile(XmlConfiguration.getRoot(), 'lib')));
            warning('on', 'MATLAB:rmpath:DirNotFound');
            
            kernel = @(u,v) kernel_matrix(u, obj.getParameter('kernel_type'), obj.getParameter('kernel_para'), v);
            obj.svmStruct = svmtrain(Xtr, Ytr, 'kernel_function', kernel);
            
            % Add again all the libraries
            addpath(genpath(fullfile(XmlConfiguration.getRoot(), 'lib')));

        end
        
        function b = checkForCompatibility(~, model)
            b = model.isOfClass('SupportVectorMachine');
        end
        
        function [labels, scores] = test_custom(obj, Xts)
            
            labels = svmclassify(obj.svmStruct, Xts);
            scores = labels;
            
        end
        
        function res = checkForPrerequisites(obj)
            if(~exist('svmclassify', 'file') == 2)
                error('Lynx:Runtime:MissingToolbox', 'The MatlabSVM training algorithm requires the Statistics Toolbox');
            end
            res = true;
        end
        
        function b = hasCustomTesting(obj)
            b = true;
        end
        
        function res = isTaskAllowed(~, t)
            res = t == Tasks.BC;
        end
        
    end
    
    methods(Static)
        function info = getDescription()
            info = 'This is a wrapper to the Support Vector Machine implemented using Matlab';
        end
    end
    
end

