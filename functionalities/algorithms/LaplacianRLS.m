classdef LaplacianRLS < SemiSupervisedLearningAlgorithm
    % LAPLACIANRLS This implements the Laplacian Regularized Least Square
    %   as descrbied in Belkin, Mikhail, Partha Niyogi, and Vikas 
    %   Sindhwani. "Manifold regularization: A geometric framework for 
    %   learning from labeled and unlabeled examples." The Journal of 
    %   Machine Learning Research 7 (2006): 2399-2434.
    
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
        
        function obj = LaplacianRLS(varargin)
            obj = obj@SemiSupervisedLearningAlgorithm(varargin);
        end
        
        function initParameters(~, p)
            p.addParamValue('C', 1, @(x) assert(x > 0, 'Regularization parameters of LapRLS must be > 0'));
            p.addParamValue('C_lap', 1, @(x) assert(x > 0, 'Regularization parameters of LapRLS must be > 0'));
            p.addParamValue('kernel_para', 1);
            p.addParamValue('n_neighbours', 7);
            p.addParamValue('normalize_laplacian', true);
        end
        
        function obj = train_semisupervised(obj, Xtr, Ytr, Xu)
            
            if(obj.getTask() == Tasks.MC)
                Ytr  = dummyvar(Ytr);
            end

            N = size(Xtr, 1);
            
            Xfull = [Xtr; Xu];
            Nu = size(Xu,1);
            obj.Xtr = Xfull;
            
            % Compute the graph Laplacian
            options.NN = obj.trainingParams.n_neighbours;
            options.GraphDistanceFunction = 'euclidean';
            options.GraphWeights = 'binary';
            options.LaplacianNormalize = obj.trainingParams.normalize_laplacian;
            options.LaplacianDegree = 1;
            L = laplacian(options, Xfull);
            
            % Compute the kernel matrix
            K = kernel_matrix(Xfull, 'rbf', obj.trainingParams.kernel_para);
            
            % J is used to extract the upper diagonal part of K
            J = diag([ones(N, 1); zeros(Nu,1)]);
            
            % Computes the output weights
            obj.outputWeights = (J*K + obj.trainingParams.C*N*eye(N+Nu) + ((obj.trainingParams.C_lap*Nu)/(N+Nu)^2)*L*K)\[Ytr; zeros(Nu, size(Ytr, 2))];
            
        end
        
        function [labels, scores] = test(obj, Xts)
            Omega_test = kernel_matrix(obj.Xtr,'rbf', obj.trainingParams.kernel_para,Xts);
            scores = (Omega_test' * obj.outputWeights);
            labels = convert_scores(scores, obj.getTask());
        end
        
        function res = isTaskAllowed(~, ~)
            res = true;
        end
    end
    
    methods(Static)
        function info = getInfo()
            info = 'Semi-Supervised version of the standard Regularized Least-Square using a manifold regularization factor extracted from the Laplacian.';
        end
        
        function pNames = getParametersNames()
            pNames = {'C', 'C_lap', 'kernel_para', 'n_neighbours', 'normalize_laplacian'}; 
        end
        
        function pInfo = getParametersInfo()
            pInfo = {'Regularization factor', 'Regularization factor for manifold term', 'Parameter of the Gaussian kernel', 'Number of neighbours while constructing the graph Laplacian', 'Normalize the Laplacian'};
        end
        
        function pRange = getParametersRange()
            pRange = {'Positive real number, default is 1', 'Positive real number, default is 1', 'Positive real number, default is 1', 'Positive integer, default is 7', 'Boolean, default is true'};
        end  
    end
    
end

