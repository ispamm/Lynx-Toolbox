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

classdef LaplacianRLS < ManifoldRegularizedLearningAlgorithm
    
    methods
        
        function obj = LaplacianRLS(model, varargin)
            obj = obj@ManifoldRegularizedLearningAlgorithm(model, varargin{:});
        end
        
        function p = initParameters(obj, p)
            p = initParameters@ManifoldRegularizedLearningAlgorithm(obj, p);
            p.addParamValue('C_lap', 1, @(x) assert(x >= 0, 'Regularization parameters of LaplacianRLS must be >= 0'));
        end
        
        function obj = train_manifold_reg(obj, dtrain, du, L)
            
            % Get training data
            Xtr = dtrain.X.data;
            Ytr = dtrain.Y.data;
            Xu = du.X.data;
            
            
            [N_train, ~] = size(Xtr);
            N_u = size(Xu, 1);
            Xfull = [Xtr; Xu];

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

    end
    
    methods(Static)
        function info = getDescription()
            info = 'Semi-Supervised version of the standard Regularized Least-Square using a manifold regularization factor extracted from the Laplacian.';
        end
        
        function pNames = getParametersNames()
            pNames = ['C_lap', ManifoldRegularizedLearningAlgorithm.getParametersNames()];
        end
        
        function pInfo = getParametersDescription()
            pInfo = ['Regularization factor for manifold term', ManifoldRegularizedLearningAlgorithm.getParametersDescription()];
        end
        
        function pRange = getParametersRange()
            pRange = ['Positive real number, default is 1',  ManifoldRegularizedLearningAlgorithm.getParametersRange()];
        end
    end
    
end

