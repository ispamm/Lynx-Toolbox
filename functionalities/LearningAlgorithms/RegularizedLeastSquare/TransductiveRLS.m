classdef TransductiveRLS < SemiSupervisedLearningAlgorithm
    % SEMISUPERVISEDELM 
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    properties
    end
    
    methods
        
        function obj = TransductiveRLS(model, varargin)
            obj = obj@SemiSupervisedLearningAlgorithm(model, varargin{:});
        end
        
        function p = initParameters(~, p)
            p.addParamValue('C_u', 1, @(x) assert(x >= 0, 'Regularization parameters of SS-RLS must be >= 0'));
            p.addParamValue('solver', 'boxcqp', @(x) assert(isingroup(x, {'boxcqp'}), 'Solver of TransductiveRLS not recognized'));
        end
        
        function obj = train_semisupervised(obj, dtrain, du)
            
            % Get training data
            Xtr = dtrain.X.data;
            Ytr = dtrain.Y.data;
            Xu = du.X.data;
            
            [N_train, d] = size(Xtr);
            N_u = size(Xu, 1);
    
            Xfull = [Xtr; Xu];

            Omega_train = kernel_matrix(Xfull, obj.getParameter('kernel_type'), obj.getParameter('kernel_para'));
            Lambda = diag([ones(N_train, 1)./obj.getParameter('C'); ones(N_u, 1)./obj.parameters.C_u]);

            P = inv(Lambda + Omega_train);
            
            if(N_u ~= 0)
                
                M = -P;
                
                M2 = M(1:N_train, N_train + 1:end);
                M3 = M(N_train+1:end, 1:N_train);
                M4 = M(N_train+1:end, N_train+1:end);

                t = (M3 + M2')*Ytr;

                Yu = boxcqp(M4, 0.5*t, -ones(N_u, 1), ones(N_u, 1));
                Zu = sign(Yu);

            else
                Zu = [];
            end
            
            Ytilde = [Ytr; Zu];
            obj.model.outputWeights = P*Ytilde;
            obj.model.Xtr = Xfull;
            
            clear H

        end

        function b = checkForCompatibility(~, model)
            b = model.isOfClass('RegularizedLeastSquare');
        end
        
        function res = isDatasetAllowed(~, d)
            res = d.task == Tasks.BC;
        end

    end
    
    methods(Static)
        function info = getDescription()
            info = '';
        end
        
        function pNames = getParametersNames()
            pNames = {'C', 'C_u', 'solver'}; 
        end
        
        function pInfo = getParametersDescription()
            pInfo = {'Regularization factor', 'Regularization factor for unsupervised term', 'Internal solver'};
        end
        
        function pRange = getParametersRange()
            pRange = {'Positive real number, default is 1', 'Positive real number, default is 1', 'String in {boxcqp [default]}'};
        end  
    end
    
end

