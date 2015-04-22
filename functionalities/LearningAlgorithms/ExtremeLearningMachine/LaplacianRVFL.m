% LaplacianRVFL - Laplacian Random Vector Fucntional-Link Network
%   This implements the Laplacian Extreme Learning Machine as descrbied
%   in Huang, Gao, et al. "Semi-supervised and unsupervised extreme
%   learning machines.", IEEE Transactions on Cybernetics (to appear).

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef LaplacianRVFL < ManifoldRegularizedLearningAlgorithm
    
    methods
        
        function obj = LaplacianRVFL(model, varargin)
            obj = obj@ManifoldRegularizedLearningAlgorithm(model, varargin{:});
        end
        
        function p = initParameters(obj, p)
            p = initParameters@ManifoldRegularizedLearningAlgorithm(obj, p);
            p.addParamValue('C', 1, @(x) assert(x > 0, 'Regularization parameter of RegularizedELM must be > 0'));
            p.addParamValue('C_lap', 1, @(x) assert(x >= 0, 'Regularization parameters of LaplacianELM must be >= 0'));
        end
        
        function obj = train_manifold_reg(obj, dtrain, du, L)
            
            % Get training data
            Xtr = dtrain.X.data;
            Ytr = dtrain.Y.data;
            Xu = du.X.data;
            
            [N_train, d] = size(Xtr);
            N_u = size(Xu, 1);
            N_hidden = obj.getParameter('hiddenNodes');
            
            Xfull = [Xtr; Xu];
            
            % STEP 2: Initialize H matrix of ELM network
            
            if(dtrain.task == Tasks.MC)
                Ytr  = dummyvar(Ytr);
            end
            
            obj.model = obj.model.generateWeights(d);
            H = obj.model.computeHiddenMatrix(Xfull);
            clear Xfull
            
            % STEP 3: Compute output weights
            
            C = diag([ones(N_train, 1).*obj.getParameter('C'); zeros(N_u, 1)]);
            Ytilde = [Ytr; zeros(N_u, size(Ytr, 2))];
            
            warning('off', 'MATLAB:nearlySingularMatrix');
            if(N_train >= N_hidden)
                obj.model.outputWeights = (eye(N_hidden) + H'*C*H + obj.parameters.C_lap.*H'*L*H)\(H'*C*Ytilde);
            else
                obj.model.outputWeights = H'*inv(eye(N_train+N_u) + C*(H*H') + obj.parameters.C_lap*L*(H*H'))*C*Ytilde;
            end
            warning('on', 'MATLAB:nearlySingularMatrix');
            
            clear H
            
        end
        
        function b = checkForCompatibility(~, model)
            b = model.isOfClass('ExtremeLearningMachine');
        end
        
    end
    
    methods(Static)
        function info = getDescription()
            info = 'Semi-Supervised version of the standard RVFL Network using a manifold regularization factor extracted from the Laplacian.';
        end
        
        function pNames = getParametersNames()
            pNames = ['C', 'C_lap', ManifoldRegularizedLearningAlgorithm.getParametersNames()];
        end
        
        function pInfo = getParametersDescription()
            pInfo = ['Regularization Factor', 'Regularization factor for manifold term', ManifoldRegularizedLearningAlgorithm.getParametersDescription()];
        end
        
        function pRange = getParametersRange()
            pRange = ['Positive real number, default is 1', 'Positive real number, default is 1',  ManifoldRegularizedLearningAlgorithm.getParametersRange()];
        end
    end
    
end

