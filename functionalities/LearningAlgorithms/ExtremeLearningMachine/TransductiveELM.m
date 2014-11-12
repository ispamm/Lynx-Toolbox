classdef TransductiveELM < SemiSupervisedLearningAlgorithm
    % SEMISUPERVISEDELM 
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    properties
    end
    
    methods
        
        function obj = TransductiveELM(model, varargin)
            obj = obj@SemiSupervisedLearningAlgorithm(model, varargin{:});
        end
        
        function p = initParameters(~, p)
            p.addParamValue('C', 1, @(x) assert(x > 0, 'Regularization parameters of SS-ELM must be > 0'));
            p.addParamValue('C_u', 1, @(x) assert(x >= 0, 'Regularization parameters of SS-ELM must be >= 0'));
            p.addParamValue('solver', 'boxcqp', @(x) assert(isingroup(x, {'boxcqp'}), 'Solver of TransductiveELM not recognized'));
        end
        
        function obj = train_semisupervised(obj, dtrain, du)
            
            % Get training data
            Xtr = dtrain.X.data;
            Ytr = dtrain.Y.data;
            Xu = du.X.data;
            
            [N_train, d] = size(Xtr);
            N_u = size(Xu, 1);
            N_hidden = obj.getParameter('hiddenNodes');
            
            Xfull = [Xtr; Xu];
            
            %obj.trainingParams.C_u = obj.trainingParams.C*(N_train/N_u);
            %obj.trainingParams.C_u = obj.trainingParams.C;
            
            obj.model = obj.model.generateWeights(d);
            H = obj.model.computeHiddenMatrix(Xfull);
            clear Xfull
            
            Lambda = diag([ones(N_train, 1).*obj.parameters.C; ones(N_u, 1).*obj.parameters.C_u]);
            
            if((N_train + N_u) >= N_hidden)
                P = (H'*Lambda*H + eye(N_hidden))\(H'*Lambda);
            else
                P = (H'/(Lambda*(H*H') + eye(N_train + N_u)))*Lambda;
            end
            
            if(N_u ~= 0)
                
                M_tmp = (H*P - eye(N_train + N_u));
                M = M_tmp'*Lambda*M_tmp + P'*P;

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
            
            clear H

        end

        function b = checkForCompatibility(~, model)
            b = model.isOfClass('ExtremeLearningMachine');
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

