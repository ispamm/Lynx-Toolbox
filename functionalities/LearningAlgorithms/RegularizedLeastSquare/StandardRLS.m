% StandardRLS - Standard RLS model
%   This is trained using an L2-regularized regression. 
%   For more information, please refer to the following paper:
%
%   [1] Evgeniou, Theodoros, Massimiliano Pontil, and Tomaso Poggio.
%   "Regularization networks and support vector machines." Advances in
%   Computational Mathematics 13.1 (2000): 1-50.
%
%   The main training operation is a NxN matrix inversion, where N is the 
%   number of training patterns. This can be parallelized on the GPU.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef StandardRLS < LearningAlgorithm
    
    properties
    end
    
    methods
        
        function obj = StandardRLS(model, varargin)
            obj = obj@LearningAlgorithm(model, varargin{:});
        end
        
        function p = initParameters(~, p)
        end
        
        function obj = train(obj, d)
            
            % Get training data
            Xtr = d.X.data;
            Ytr = d.Y.data;
            
            if(d.task == Tasks.MC)
                Ytr  = dummyvar(Ytr);
            end
            
            obj.model.Xtr = Xtr;
            [N, ~] = size(Xtr);
            
            if(strcmp(obj.getParameter('kernel_type'), 'custom'))
                Omega_train = Xtr;
            else
                Omega_train = kernel_matrix(Xtr, obj.getParameter('kernel_type'), obj.getParameter('kernel_para'));
            end

            zeroC = false;
            if(obj.getParameter('C') == 0)
                empiricalVariance = (1/size(Xtr,1))*trace(Omega_train) - (1/size(Xtr,1)^2)*sum(sum(Omega_train));
                obj = obj.setParameter('C', 1/empiricalVariance);
                zeroC = true;
           end
            
            warning('off', 'MATLAB:singularMatrix');
            warning('off', 'MATLAB:nearlySingularMatrix');
            warning('off', 'MATLAB:illConditionedMatrix');
            if(isa(Xtr, 'gpuArray'))
                obj.model.outputWeights =(Omega_train + gpuArray.eye(N)/obj.getParameter('C'))\Ytr;
                obj.model.outputWeights = gather(obj.model.outputWeights);
            else
                tmp = Omega_train + speye(N)/obj.getParameter('C');
                obj.model.outputWeights =tmp\Ytr;
            end
            warning('on', 'MATLAB:singularMatrix');
            warning('on', 'MATLAB:nearlySingularMatrix');
            warning('on', 'MATLAB:illConditionedMatrix');

            [~, lw] = lastwarn;
            lastwarn('');

            if(strcmp(lw, 'MATLAB:singularMatrix') || strcmp(lw, 'MATLAB:nearlySingularMatrix') ...
                    ||  strcmp(lw, 'MATLAB:illConditionedMatrix'))
                obj.model.outputWeights = [];
            end
            
            if(zeroC)
                obj = obj.setParameter('C', 0);
            end
        end
        
        function b = checkForCompatibility(~, model)
            b = model.isOfClass('RegularizedLeastSquare');
        end
        
        function b = hasGPUSupport(obj)
            b = true;
        end
        
    end
    
    methods(Static)
        function info = getDescription()
            info = 'RLS trained using standard L2-regularized regression. For more information, please refer to the following paper: Evgeniou, Theodoros, Massimiliano Pontil, and Tomaso Poggio. "Regularization networks and support vector machines." Advances in Computational Mathematics 13.1 (2000): 1-50.';
        end
        
        function pNames = getParametersNames()
            pNames = {'C'}; 
        end
        
        function pInfo = getParametersDescription()
            pInfo = {};
        end
        
        function pRange = getParametersRange()
            pRange = {};
        end  
    end
    
end

