% SVMLight - A class wrapping the SVMLight library
% This can be used for semi-supervised learning, which is implemented with
% the following algorithm:
%
%   [1] Thorsten Joachims, Learning to Classify Text Using Support Vector 
%       Machines. Dissertation, Kluwer, 2002.
%
% It uses the utility functions developed by Neil Lawrence:
% http://staffwww.dcs.shef.ac.uk/people/N.Lawrence/software/svml_toolbox.html
%
% Note that SVMLight must be installed on the system prior to the
% execution. Custom kernel is currently not supported.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef SVMLight < SemiSupervisedLearningAlgorithm
    
    properties
        svmStruct;
    end
    
    methods
        
        function obj = SVMLight(model, varargin)
            obj = obj@SemiSupervisedLearningAlgorithm(model, varargin{:});
        end
        
        function p = initParameters(~, p)
        end
        
        function obj = train_semisupervised(obj, dtrain, du)
            
            % Get training data
            Xtr = dtrain.X.data;
            Ytr = dtrain.Y.data;
            Xu = du.X.data;
            
            if(dtrain.task == Tasks.R)
                z = 1;
            else
                z = 0;
            end
            
            % Initialize the SVMLight structure
            obj.svmStruct = svml(fullfile(XmlConfiguration.getRoot(), 'tmp', 'svmlight_model'), 'C', obj.getParameter('C'), 'Kernel', obj.getKernelID(), ...
                'KernelParam', obj.getParameter('kernel_para'), 'Verbosity', 0, 'Regression', z);
            
            % Train
            [~, obj.svmStruct] = evalc('svmltrain(obj.svmStruct, [Xtr; Xu], [Ytr; zeros(size(Xu, 1), 1)])');
            
        end
        
        function b = checkForCompatibility(~, model)
            b = model.isOfClass('SupportVectorMachine') && ~strcmp(model.getParameter('kernel_type'), 'custom');
            
        end
        
        function [labels, scores] = test_custom(obj, d)
            
            % Get test data
            Xts = d.X.data;
            
            % Get predictions
            [~, scores] = evalc('svmlfwd(obj.svmStruct, Xts)');
            labels = convert_scores(scores, d.task);
            
            
        end
        
        function res = checkForPrerequisites(obj)
            % First, we check the availability of the SVMLight executables
            fprintf('Checking availability of SVMLight on system''s path...\n');
            if(isunix)
                [status, ~] = unix('svm_classify');
            else
                [status, ~] = dos('svm_classify');
            end
            if(status == 1)
                error('Lynx:RunTime:MissingExecutable', 'The SVMLight executables are not available on the system''s path');
            end
            
            % Next, we download the utility functions
            res = LibraryHandler.checkAndInstallLibrary('svmlight-matlab', 'SVMLight-MATLAB', 'http://staffwww.dcs.shef.ac.uk/people/N.Lawrence/software/svml_v092.tar.gz', ...
                'SVMLight training algorithm');
        end
        
        function b = hasCustomTesting(obj)
            b = true;
        end
        
        function res = isDatasetAllowed(obj, d)
            res = d.task == Tasks.BC || d.task == Tasks.R;
            res = res && obj.model.isDatasetAllowed(d);
        end
        
        function id = getKernelID(obj)
            % Convert the internal string for the kernel to the
            % corresponding ID in SVMLight
            switch obj.getParameter('kernel_type')
                case 'rbf'
                    id = 2;
                case 'lin'
                    id = 0;
                case 'poly'
                    id = 1;
            end
        end
            
        
    end
    
    methods(Static)
        function info = getDescription()
            info = 'This is a wrapper to the Support Vector Machine implemented using SVMLight';
        end
    end
    
end

