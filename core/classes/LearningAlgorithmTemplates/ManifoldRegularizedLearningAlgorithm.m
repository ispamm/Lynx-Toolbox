% ManifoldRegularizedLearningAlgorithm - LA with manifold regularization
%   This represents a generic semi-supervised learning algorithm with
%   manifold regularization. It automatically constructs the Laplacian from
%   training and unlabeled data, and subsequently calls a specialized
%   training method (to be implemented in subclasses).
%
%   For more information on manifold regularization, see:
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

classdef ManifoldRegularizedLearningAlgorithm < SemiSupervisedLearningAlgorithm
    
    methods
        
        function obj = ManifoldRegularizedLearningAlgorithm(model, varargin)
            obj = obj@SemiSupervisedLearningAlgorithm(model, varargin{:});
        end
        
        function p = initParameters(obj, p)
            p.addParamValue('n_neighbors', 10);
            p.addParamValue('normalize_laplacian', true);
            p.addParamValue('laplacian_degree', 1, @(x) assert(isnatural(x, false), 'Degree of the Laplacian must be a natural number'));
        end
        
        function obj = train_semisupervised(obj, dtrain, du)
            
            % Get training data
            Xtr = dtrain.X.data;
            Xu = du.X.data;
            
            % Construct the graph Laplacian
            Xfull = [Xtr; Xu];
            
            options = make_options('NN', obj.parameters.n_neighbors);
            options.Verbose = 0;
            options.LaplacianNormalize = obj.parameters.normalize_laplacian;
            options.LaplacianDegree = obj.parameters.laplacian_degree;
            
            L = laplacian(options,Xfull);

            obj = obj.train_manifold_reg(dtrain, du, L);
            
        end

        function res = checkForPrerequisites(obj)
            res = LibraryHandler.checkAndInstallLibrary('lapsvm', 'Primal Laplacian SVM', ...
                'http://www.dii.unisi.it/~melacci/lapsvmp/lapsvmp_v02.zip', ...
                'Laplacian computation in manifold-regularized training algorithms');
        end
        
    end
    
    methods(Abstract)
        % Abstract function to be implemented
        obj = train_manifold_reg(dtrain, du, L);
    end
    
    methods(Static)

        function pNames = getParametersNames()
            pNames = {'n_neighbors', 'normalize_laplacian','laplacian_degree'};
        end
        
        function pInfo = getParametersDescription()
            pInfo = {'Number of neighbors while constructing the graph Laplacian', 'Normalize the Laplacian', 'Degree of the Laplacian'};
        end
        
        function pRange = getParametersRange()
            pRange = {'Positive integer, default is 7', 'Boolean, default is true', 'Positive integer, default is 50', 'Positive integer, default is 1'};
        end
        
    end
    
end

