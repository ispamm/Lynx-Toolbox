% LibSVM - A class wrapping the Support Vector Machine of LibSVM

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef LibSVM < LearningAlgorithm
    
    properties
        svmStruct;
        Xtr;
    end
    
    methods
        
        function obj = LibSVM(model, varargin)
            obj = obj@LearningAlgorithm(model, varargin{:});
        end
        
        function p = initParameters(~, p)
        end
        
        function obj = train(obj, d)
            
            % Get training data
            Xtr = d.X.data;
            Ytr = d.Y.data;
            
            % Needed for custom kernel
            if(strcmp(obj.getParameter('kernel_type'), 'custom') && (any(isnan(Xtr(:))) || rcond(Xtr) < 10^-8))
                obj.svmStruct = [];
                return;
            end
            
            % Save the input points
            obj.Xtr = Xtr;
            
            % Compute the kernel matrix
            if(~strcmp(obj.getParameter('kernel_type'), 'custom'))
                Xtr = kernel_matrix(Xtr, obj.getParameter('kernel_type'), obj.getParameter('kernel_para'));
            end
            
            if(d.task == Tasks.R)
                options = ['-s 4 -t 4 -c ',  ...
                    num2str(obj.getParameter('C')), ' -h 0 -q 1 -n ',  num2str(obj.getParameter('nu'))];
                Xtr = [(1:size(Xtr,1))' Xtr];
                
            else
                
                options = ['-t 4 -c ',  num2str(obj.getParameter('C')), ' -h 0 -q 1'];
                Xtr = [(1:size(Xtr,1))' Xtr];
                
            end
            obj.svmStruct = svmtrain(Ytr, Xtr, options);
            
        end
        
        function b = checkForCompatibility(~, model)
            b = model.isOfClass('SupportVectorMachine');
        end
        
        function [labels, scores] = test_custom(obj, d)
            
            % Get test data
            Xts = d.X.data;
            
            if(~isempty(Xts) && ~isempty(obj.svmStruct))
                
                if(~strcmp(obj.getParameter('kernel_type'), 'custom'))
                    Xts = kernel_matrix(obj.Xtr, obj.getParameter('kernel_type'), obj.getParameter('kernel_para'), Xts)';
                end
                
                Xts = [(1:size(Xts,1))' Xts];
                [labels, ~, scores] = svmpredict(zeros(size(Xts, 1),1), Xts(:, :), obj.svmStruct, '-q 1');
                
            else
                
                scores = zeros(size(Xts, 1), 1);
                labels = convert_scores(scores, obj.getCurrentTask());
                
            end
            
        end
        
        function res = checkForPrerequisites(obj)
            res = LibraryHandler.checkAndInstallLibrary('libsvm', 'LibSVM', 'https://github.com/cjlin1/libsvm/archive/v321.zip', ...
                'LibSVM training algorithm');
        end
        
        function b = hasCustomTesting(obj)
            b = true;
        end
        
    end
    
    methods(Static)
        function info = getDescription()
            info = 'This is a wrapper to the Support Vector Machine implemented using LibSVM';
        end
    end
    
end

