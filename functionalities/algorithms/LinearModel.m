
classdef LinearModel < LearningAlgorithm
    % LINEARMODEL Regularized Least-Square regression with a linear model.
    %   All parameters are name/value. Depending on the alpha parameter,
    %   the regularization term and the training algorithms are different:
    %
    %   add_algorithm('L', 'Linear', @LinearModel, 'alpha', 0) you obtain 
    %   an L2-regularized model (i.e., ridge regression).
    %
    %   add_algorithm('L', 'Linear', @LinearModel, 'alpha', p), with
    %   p = ]0,1], you obtain a model regularized with a mixture of L1 and 
    %   L2 regularization using the LASSO algorithm. This last one is
    %   implemented using the 'lasso' function in the Statistics Toolbox of
    %   Matlab.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    properties
        beta;
    end
    
    methods
        
        % regularization is a boolean indicating whether to include some
        % form of validation. If alpha is in (0,1], an elastic-net
        % penalization is included, validated with parameter given by
        % valParam. If alpha = 0, an L2-regularization is included, with
        % lambda = valParam.
        function obj = LinearModel(varargin)
            obj = obj@LearningAlgorithm(varargin);
        end
        
        function initParameters(~, p)
            p.addParamValue('regularization', true, @(x) assert(islogical(x), 'Regularization parameter of the linear model must be a boolean'));
            p.addParamValue('alpha', 0, @(x) assert(x >= 0 && x <= 1, 'Alpha must be comprised in [0,1]'));
            p.addParamValue('valParam', 3);
        end
        
        function obj = train(obj, Xtr, Ytr)
            if(~obj.trainingParams.regularization)
                obj.beta = [ones(size(Xtr,1), 1) Xtr]\Ytr;
            else
                if(obj.trainingParams.alpha > 0)
                    cv = get_partition(Ytr, obj.trainingParams.valParam);
                    [models, modelsInfo] = lasso(Xtr,Ytr, 'Alpha', obj.trainingParams.alpha, 'CV', cv, 'Standardize', false);
                    [~, minMSEindex] = min(modelsInfo.MSE);
                    obj.beta = [modelsInfo.Intercept(minMSEindex); models(:, minMSEindex)];
                else
                    X = [ones(size(Xtr,1), 1) Xtr];
                    obj.beta = (X'*X + obj.trainingParams.valParam*ones(size(Xtr,2)+1))\(X'*Ytr);
                end
            end
        end
        
        function [labels, scores] = test(obj, Xts)
                labels = [ones(size(Xts,1), 1) Xts]*obj.beta;
                scores = labels;
        end
        
        function res = isTaskAllowed(~, task)
            res = (task ~= Tasks.MC);
        end
    end
    
    methods(Static)
        function info = getInfo()
            info = ['Regularized Least-Square regression with a linear model. ' ...
                'For alpha=0, you obtain an L2-regularized model (i.e., ridge regression). ' ...
                'For alpha = ]0,1], you obtain a model regularized with a mixture of L1 and L2 regularization ' ...
                'using the LASSO algorithm. This last one is implemented using the ''lasso'' function in the ' ...
                'Statistics Toolbox of Matlab.'];
        end
        
        function pNames = getParametersNames()
            pNames = {'regularization', 'alpha', 'valParam'}; 
        end
        
        function pInfo = getParametersInfo()
            pInfo = {'Boolean that activate regularization', 'Balance between L1 and L2 regularization (0 for pure ridge regression)', 'Validation parameter'};
        end
        
        function pRange = getParametersRange()
            pRange = {'Boolean, default is false', '[0, 1], default  is0', '[0,1] or positive integer, default is 3'};
        end 
    end
    
end

