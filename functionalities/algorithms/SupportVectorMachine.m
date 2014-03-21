classdef SupportVectorMachine < LearningAlgorithm
    % SUPPORTVECTORMACHINE A class wrapping the Support Vector Machine of
    % LibSVM. All parameters are name/value.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    properties
        svmStruct;
    end
    
    methods
        
        function obj = SupportVectorMachine(varargin)
            obj = obj@LearningAlgorithm(varargin);
        end
        
        function initParameters(~, p)
            p.addParamValue('C', 1, @(x) assert(x > 0, 'Regularization parameter of SVM must be > 0'));
            p.addParamValue('kernel_type', 'rbf', @(x) assert(ismember('x', {'rbf', 'custom'}), 'Kernel type not recognized in SVM'));
            p.addParamValue('kernel_parameter', 1);
            p.addParamValue('nu', 0.1);
        end
        
        function obj = train(obj, Xtr, Ytr)

            % Needed for custom kernel
            if(strcmp(obj.trainingParams.kernel_type, 'custom') && (any(isnan(Xtr(:))) || rcond(Xtr) < 10^-6))
                obj.svmStruct = [];
                return;
            end
            
            if(obj.trainingParams.C == 0)
                if(strcmp(obj.trainingParams.kernel_type, 'custom'))
                    Omega_train = Xtr;
                else
                    Omega_train = kernel_matrix(Xtr, obj.trainingParams.kernel_type, obj.trainingParams.kernel_parameter);
                end

                obj.trainingParams.C = 1/(trace(Omega_train)/size(Xtr,1));
           end
            
            
            if(obj.getTask() == Tasks.R)
                if(strcmp(obj.trainingParams.kernel_type, 'custom'))
                    options = ['-s 4 -t 4 -c ',  ...
                        num2str(obj.trainingParams.C), ' -h 0 -q 1 -n ',  num2str(obj.trainingParams.nu)];
                    Xtr = [(1:size(Xtr,1))' Xtr];
                else
                    options = ['-s 4 -g ', num2str(obj.trainingParams.kernel_parameter), ' -c ',  ...
                        num2str(obj.trainingParams.C), ' -h 0 -q 1 -n ',  num2str(obj.trainingParams.nu)];
                end
            else
                if(strcmp(obj.trainingParams.kernel_type, 'custom'))
                    options = ['-t 4 -c ',  num2str(obj.trainingParams.C), ' -h 0 -q 1'];
                    Xtr = [(1:size(Xtr,1))' Xtr];
                else
                    options = ['-g ', num2str(obj.trainingParams.kernel_parameter), ' -c ',  num2str(obj.trainingParams.C), ' -h 0 -q 1'];
                end
            end
            obj.svmStruct = svmtrain(Ytr(:), Xtr(:,:), options);
            
        end
        
        function [labels, scores] = test(obj, Xts)
            
             if(~isempty(Xts) && ~isempty(obj.svmStruct))
        
                 if(strcmp(obj.trainingParams.kernel_type, 'custom'))
                    Xts = [(1:size(Xts,1))' Xts];
                 end
                [labels, ~, scores] = svmpredict(zeros(size(Xts, 1),1), Xts(:, :), obj.svmStruct, '-q 1');
        
             else
                 
                scores = zeros(size(Xts, 1), 1);
                labels = convert_scores(scores, obj.getTask());
                
             end
             
        end
        
        function res = isTaskAllowed(~, ~)
            res = true;
        end
    
    end
    
    methods(Static)
        function info = getInfo()
            info = 'This is a wrapper to the Support Vector Machine with RBF or custom kernel implemented using LibSVM.';
        end
        
        function pNames = getParametersNames()
            pNames = {'C', 'kernel_type', 'kernel_parameter', 'nu'}; 
        end
        
        function pInfo = getParametersInfo()
            pInfo = {'Regularization factor', 'Kernel function', 'Kernel parameters', 'Nu parameter in nu-SVM'};
        end
        
        function pRange = getParametersRange()
            pRange = {'Positive real number, default is 1', 'String in {rbf, custom}, default is rbf', 'Real number, default is 1', ...
                'Real number in [0, 1], default is 0.1'};
        end 
    end
    
end

