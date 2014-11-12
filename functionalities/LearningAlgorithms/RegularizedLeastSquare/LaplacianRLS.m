% LaplacianRLS - Laplacian Regularized Least-Square
%   For more information, see the paper:
%
%   [1] Belkin, M., Niyogi, P., & Sindhwani, V. (2006). Manifold 
%   regularization: A geometric framework for learning from labeled and 
%   unlabeled examples. The Journal of Machine Learning Research, 7, 
%   2399-2434.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef LaplacianRLS < SemiSupervisedLearningAlgorithm
    
    methods
        
        function obj = LaplacianRLS(model, varargin)
            obj = obj@SemiSupervisedLearningAlgorithm(model, varargin{:});
        end
        
        function p = initParameters(obj, p)
            p.addParamValue('C_lap', 1, @(x) assert(x >= 0, 'Regularization parameters of LaplacianRLS must be >= 0'));
            p.addParamValue('n_neighbors', 10);
            p.addParamValue('normalize_laplacian', true);
            p.addParamValue('laplacian_degree', 1, @(x) assert(isnatural(x, false), 'Degree of the Laplacian of LaplacianELM must be a natural number'));
        end
        
        function obj = train_semisupervised(obj, dtrain, du)
            
            % Get training data
            Xtr = dtrain.X.data;
            Ytr = dtrain.Y.data;
            Xu = du.X.data;
            
            % STEP 1: Construct the graph Laplacian
            
            [N_train, ~] = size(Xtr);
            N_u = size(Xu, 1);
            Xfull = [Xtr; Xu];
            
            % generating default options
            options = make_options('NN',obj.parameters.n_neighbors);
            options.Verbose=0;
            options.LaplacianNormalize = obj.parameters.normalize_laplacian;
            options.LaplacianDegree = obj.parameters.laplacian_degree;
            
            L = laplacian(options,Xfull);

            if(dtrain.task == Tasks.MC)
                Ytr  = dummyvar(Ytr);
            end
            
            % STEP 3: Compute output weights
            
            C = diag([ones(N_train, 1).*obj.getParameter('C'); zeros(N_u, 1)]);
            Omega = kernel_matrix(Xfull, obj.getParameter('kernel_type'), obj.getParameter('kernel_para'));
            Ytilde = [Ytr; zeros(N_u, size(Ytr, 2))];
            
            obj.model.outputWeights = (eye(N_train + N_u) + C*Omega + obj.parameters.C_lap.*L*Omega)\(C*Ytilde);
            obj.model.Xtr = Xfull;
            
        end
        
        function b = checkForCompatibility(~, model)
            b = model.isOfClass('RegularizedLeastSquare');
        end
        
        function res = checkForPrerequisites(obj)
            res = LibraryHandler.checkAndInstallLibrary('lapsvm', 'Primal Laplacian SVM', ...
                'http://www.dii.unisi.it/~melacci/lapsvmp/lapsvmp_v02.zip', ...
                'Laplacian computation of LaplacianELM');
        end
        
    end
    
    methods(Static)
        function info = getDescription()
            info = 'Semi-Supervised version of the standard Regularized Least-Square using a manifold regularization factor extracted from the Laplacian.';
        end
        
        function pNames = getParametersNames()
            pNames = {'C_lap', 'n_neighbors', 'normalize_laplacian','laplacian_degree'};
        end
        
        function pInfo = getParametersDescription()
            pInfo = {'Regularization factor for manifold term', 'Number of neighbors while constructing the graph Laplacian', 'Normalize the Laplacian', 'Degree of the Laplacian'};
        end
        
        function pRange = getParametersRange()
            pRange = {'Positive real number, default is 1',  'Positive integer, default is 7', 'Boolean, default is true', 'Positive integer, default is 50', 'Positive integer, default is 1'};
        end
    end
    
end

