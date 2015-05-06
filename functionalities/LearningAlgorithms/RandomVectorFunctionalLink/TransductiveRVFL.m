classdef TransductiveRVFL < SemiSupervisedLearningAlgorithm
    % TransductiveRVFL - Transductive RVFL network
    % 
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    properties
    end
    
    methods
        
        function obj = TransductiveRVFL(model, varargin)
            obj = obj@SemiSupervisedLearningAlgorithm(model, varargin{:});
        end
        
        function p = initParameters(~, p)
            p.addParamValue('C', 1, @(x) assert(x > 0, 'Regularization parameters of SS-ELM must be > 0'));
            p.addParamValue('C_u', 1, @(x) assert(x >= 0, 'Regularization parameters of SS-ELM must be >= 0'));
            p.addParamValue('solver', 'scip', @(x) assert(isingroup(x, {'scip', 'boxcqp', 'ga'}), 'Solver of TransductiveELM not recognized'));
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
                
                if(strcmp(obj.getParameter('solver'), 'scip'))
                    
                    Ytr_new = Ytr;
                    Ytr_new(Ytr == -1) = 0;
                    t = 0.5*(M3 + M2')*Ytr_new;
                    
                    opts.maxnodes = 10000;
                    Zu = scip(sparse(M4), t, [], [], [], [], [], ...
                        repmat('b', 1, N_u), [], [], [], opts);
                    Zu = 2*Zu - ones(N_u, 1);
                   
                elseif(strcmp(obj.getParameter('solver'), 'boxcqp'))
                   
                    t = 0.5*(M3 + M2')*Ytr;
                    Zu = boxcqp(M4, t, -ones(N_u, 1), ones(N_u, 1));
                    Zu = sign(Zu);
                    
                elseif(strcmp(obj.getParameter('solver'), 'ga'))
                    
                    Ytr_new = Ytr;
                    Ytr_new(Ytr == -1) = 0;
                    t = (M3 + M2')*Ytr_new;
                    
                    options = gaoptimset('PopulationType', 'bitstring', 'Display', 'none');
                    Zu = ga(@(y) 0.5*(y*M4*y' + y*t), N_u, [], [], [], [], [], [], [], options);
                    Zu = 2*Zu(:) - ones(N_u, 1);
                    
                end

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
        
        function res = checkForPrerequisites(obj)
            % Check for prerequisites
            if(strcmp(obj.parameters.solver, 'scip') && ~(exist('scip', 'file') == 3))
                error('Lynx:Library:MissingLibrary', 'TransductiveRVFL: you must install the OPTI Toolbox for the SCIP solver');
            end
            res = true;
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

