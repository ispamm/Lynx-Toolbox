classdef RegularizationNetwork < LearningAlgorithm
    % REGULARIZATIONNETWORK Regularization Network trained using 
    %   L2-regularized regression. For more information, please refer to 
    %   the following paper: 
    %
    %   [1] Evgeniou, Theodoros, Massimiliano Pontil, and Tomaso Poggio. 
    %   "Regularization networks and support vector machines." Advances in 
    %   Computational Mathematics 13.1 (2000): 1-50.
    %
    %   All parameters are name/value. The main training operation is a NxN
    %   matrix inversion, where N is the number of training patterns. This
    %   can be parallelized on the GPU.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    properties
        Xtr;
        outputWeights;
    end
    
    methods
        
        function obj = RegularizationNetwork(varargin)
            obj = obj@LearningAlgorithm(varargin);
        end
        
        function initParameters(~, p)
            p.addParamValue('C', 1, @(x) assert(x > 0, 'Regularization parameter of RN must be > 0'));
            p.addParamValue('kernel_type', 'rbf', @(x) assert(ischar('x'), 'Kernel type must be a string'));
            p.addParamValue('kernel_para', 1);
        end
        
        function obj = train(obj, Xtr, Ytr)
            
            if(obj.getTask() == Tasks.MC)
                Ytr  = dummyvar(Ytr);
            end
            
            obj.Xtr = Xtr;
            [N, ~] = size(Xtr);
            
            log = SimulationLogger.getInstance();
            if(log.flags.gpu_enabled)
                Xtr = gpuArray(Xtr);
                Ytr = gpuArray(Ytr);
            end
            
            if(strcmp(obj.trainingParams.kernel_type, 'custom'))
                Omega_train = Xtr;
            else
                Omega_train = kernel_matrix(Xtr, obj.trainingParams.kernel_type, obj.trainingParams.kernel_para);
            end

            zeroC = false;
            if(obj.trainingParams.C == 0)
                empiricalVariance = (1/size(Xtr,1))*trace(Omega_train) - (1/size(Xtr,1)^2)*sum(sum(Omega_train));
                obj.trainingParams.C = 1/empiricalVariance;
                zeroC = true;
           end
            
            warning('off', 'MATLAB:singularMatrix');
            warning('off', 'MATLAB:nearlySingularMatrix');
            warning('off', 'MATLAB:illConditionedMatrix');
            if(log.flags.gpu_enabled)
                obj.outputWeights =(Omega_train + gpuArray.eye(N)/obj.trainingParams.C)\Ytr;
                obj.outputWeights = gather(obj.outputWeights);
            else
                tmp = Omega_train + speye(N)/obj.trainingParams.C;
                obj.outputWeights =tmp\Ytr;
            end
            warning('on', 'MATLAB:singularMatrix');
            warning('on', 'MATLAB:nearlySingularMatrix');
            warning('on', 'MATLAB:illConditionedMatrix');

            [~, lw] = lastwarn;
            lastwarn('');

            if(strcmp(lw, 'MATLAB:singularMatrix') || strcmp(lw, 'MATLAB:nearlySingularMatrix') ...
                    ||  strcmp(lw, 'MATLAB:illConditionedMatrix'))
                obj.outputWeights = [];
            end
            
            if(zeroC)
                obj.trainingParams.C = 0;
            end
        end
        
        function [labels, scores] = test(obj, Xts)
            if(isempty(obj.outputWeights))
                scores = zeros(size(Xts, 1), 1);
            else
                if(strcmp(obj.trainingParams.kernel_type, 'custom'))
                    Omega_test = Xts';
                else
                    Omega_test = kernel_matrix(obj.Xtr,obj.trainingParams.kernel_type, obj.trainingParams.kernel_para,Xts);
                end
                scores = (Omega_test' * obj.outputWeights);
            end
            labels = convert_scores(scores, obj.getTask());
        end
        
        function res = isTaskAllowed(~, ~)
            res = true;
        end
    end
    
    methods(Static)
        function info = getInfo()
            info = 'Regularization Network trained using L2-regularized regression. For more information, please refer to the following paper: Evgeniou, Theodoros, Massimiliano Pontil, and Tomaso Poggio. "Regularization networks and support vector machines." Advances in Computational Mathematics 13.1 (2000): 1-50.';
        end
        
        function pNames = getParametersNames()
            pNames = {'C', 'kernel_type', 'kernel_para'}; 
        end
        
        function pInfo = getParametersInfo()
            pInfo = {'Regularization factor', 'Kernel function', 'Kernel parameters'};
        end
        
        function pRange = getParametersRange()
            pRange = {'Positive real number, default is 1', 'See help kernel_matrix, default is rbf', 'Vector of real numbers, see help kernel_matrix, default is 1'};
        end  
    end
    
end

