% LaplacianELM - Laplacian Extreme Learning Machine
%   This implements the Laplacian Extreme Learning Machine as descrbied
%   in Huang, Gao, et al. "Semi-supervised and unsupervised extreme
%   learning machines.", IEEE Transactions on Cybernetics (to appear).

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef LaplacianELM < SemiSupervisedLearningAlgorithm
    
    methods
        
        function obj = LaplacianELM(model, varargin)
            obj = obj@SemiSupervisedLearningAlgorithm(model, varargin{:});
        end
        
        function p = initParameters(obj, p)
            p.addParamValue('C', 1, @(x) assert(x > 0, 'Regularization parameter of RegularizedELM must be > 0'));
            p.addParamValue('C_lap', 1, @(x) assert(x >= 0, 'Regularization parameters of LaplacianELM must be >= 0'));
            p.addParamValue('n_neighbors', 7);
            p.addParamValue('normalize_laplacian', true);
            p.addParamValue('laplacian_degree', 1, @(x) assert(isnatural(x, false), 'Degree of the Laplacian of LaplacianELM must be a natural number'));
        end
        
        function obj = train_semisupervised(obj, dtrain, du)
            
            % Get training data
            Xtr = dtrain.X.data;
            Ytr = dtrain.Y.data;
            Xu = du.X.data;
            
            % STEP 1: Construct the graph Laplacian
            
            [N_train, d] = size(Xtr);
            N_u = size(Xu, 1);
            N_hidden = obj.getParameter('hiddenNodes');
            
            Xfull = [Xtr; Xu];
            
            % generating default options
            options = make_options('NN',obj.parameters.n_neighbors);
            options.Verbose=0;
            options.LaplacianNormalize = obj.parameters.normalize_laplacian;
            options.LaplacianDegree = obj.parameters.laplacian_degree;
            
            L = laplacian(options,Xfull);
            
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
            
            if(N_train >= N_hidden)
                obj.model.outputWeights = (eye(N_hidden) + H'*C*H + obj.parameters.C_lap.*H'*L*H)\(H'*C*Ytilde);
            else
                obj.model.outputWeights = H'*inv(eye(N_train+N_u) + C*(H*H') + obj.parameters.C_lap*L*(H*H'))*C*Ytilde;
            end
            
            clear H
            
        end
        
        function b = checkForCompatibility(~, model)
            b = model.isOfClass('ExtremeLearningMachine');
        end
        
        function res = checkForPrerequisites(obj)
            res = LibraryHandler.checkAndInstallLibrary('lapsvm', 'Primal Laplacian SVM', ...
                'http://www.dii.unisi.it/~melacci/lapsvmp/lapsvmp_v02.zip', ...
                'Laplacian computation of LaplacianELM');
        end
        
    end
    
    methods(Static)
        function info = getDescription()
            info = 'Semi-Supervised version of the standard Extreme Learning Machine using a manifold regularization factor extracted from the Laplacian.';
        end
        
        function pNames = getParametersNames()
            pNames = {'C', 'C_lap', 'n_neighbors', 'normalize_laplacian','laplacian_degree'};
        end
        
        function pInfo = getParametersDescription()
            pInfo = {'Regularization Factor', 'Regularization factor for manifold term', 'Number of neighbors while constructing the graph Laplacian', 'Normalize the Laplacian', 'Degree of the Laplacian'};
        end
        
        function pRange = getParametersRange()
            pRange = {'Positive real number, default is 1','Positive real number, default is 1',  'Positive integer, default is 7', 'Boolean, default is true', 'Positive integer, default is 50', 'Positive integer, default is 1'};
        end
    end
    
end

