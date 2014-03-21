classdef KernelRecursiveLeastSquare < LearningAlgorithm
    % KERNELRECURSIVELEASTSQUARE 'Kernel Recursive Least-Square algorithm, 
    %   including four sparsification criteria: Novelty Criterion, Surprise
    %   Criterion, Approximate Linear Dependency and Fixed-Budget. The last
    %   two criteria are implemented by calling the Kernel Methods Toolbox,
    %   which has to be installed on the system. For more information on
    %   the algorithm, refer to the book 'Kernel Adaptive Filtering' by
    %   Principe et al.
    %
    %   The algorithm accepts several parameters, all in name/value form.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
        
    
    properties
        expansionCoefficient;
        dictionaryIndex;
        Xtr;
        vars;
        pars;
    end
    
    methods
        
        function obj = KernelRecursiveLeastSquare(varargin)
            obj = obj@LearningAlgorithm(varargin);
        end
        
        function initParameters(~, p)
            p.addParamValue('kernel_type', 'rbf', @(x) assert(ismember('x', {'rbf', 'custom'}), 'Kernel type not recognized in KRLS'));
            p.addParamValue('kernel_parameter', 1);
            p.addParamValue('C', 1, @(x) assert(x > 0, 'Regularization parameter of KRLS must be > 0'));
            p.addParamValue('maxIterations', Inf);
            p.addParamValue('criterion', 'none');
            p.addParamValue('cParam1', 0);
            p.addParamValue('cParam2', 0);
        end
        
        function obj = train(obj, Xtr, Ytr)
            
            obj.Xtr = Xtr;
            [N,~] = size(Xtr);

            if(obj.trainingParams.maxIterations > N)
                stoppingIteration = N;
            else
                stoppingIteration = obj.trainingParams.maxIterations;
            end
            
            if(strcmp(obj.trainingParams.criterion, 'fb') || strcmp(obj.trainingParams.criterion, 'ald'))
     
                if(strcmp(obj.trainingParams.criterion, 'fb'))
                    obj.pars.algo = 'fb-krls';
                    obj.pars.M = obj.trainingParams.cParam1;
                elseif(strcmp(obj.trainingParams.criterion, 'ald'))
                    obj.pars.algo = 'ald-krls';
                    obj.pars.thresh = obj.trainingParams.cParam1;
                end
                
                obj.pars.c = obj.trainingParams.C;
                obj.pars.kernel.type = 'gauss';
                obj.pars.kernel.par = sqrt(1/(2*obj.trainingParams.kernel_parameter));
                
                obj.pars.mu = 0;
    
                
                if(strcmp(obj.trainingParams.criterion, 'fb'))
                    fcn = @km_fbkrls;
                elseif(strcmp(obj.trainingParams.criterion, 'ald'))
                    fcn = @km_aldkrls;
                end
                
                for i=1:stoppingIteration
                    
                    obj.vars.t = i;
                    obj.vars = fcn(obj.vars, obj.pars, Xtr(i,:), Ytr(i));
                    
                end
                
            else

                Q_matrix = 1/(obj.trainingParams.C + kernel_matrix(Xtr(1, :), obj.trainingParams.kernel_type, ...
                    obj.trainingParams.kernel_parameter, Xtr(1, :)));
                obj.expansionCoefficient = Q_matrix*Ytr(1);

                NC = zeros(1, N);
                
                % dictionary
                obj.dictionaryIndex = 1;
                dictSize = 1;

                for n = 2:stoppingIteration

                if(strcmp(obj.trainingParams.criterion, 'nc'))

                    distance2dictionary = min(sum((repmat(Xtr(n,:), dictSize, 1) - Xtr(obj.dictionaryIndex,:)).^2, 2));
                    if (distance2dictionary < obj.trainingParams.cParam1)
                        continue;
                    end

                end

                k_vector = kernel_matrix(Xtr(n,:), obj.trainingParams.kernel_type, ...
                    obj.trainingParams.kernel_parameter, Xtr(obj.dictionaryIndex, :));
                k_vector = k_vector';
                networkOutput = obj.expansionCoefficient*k_vector;
                predictionError = Ytr(n) - networkOutput;

                if(strcmp(obj.trainingParams.criterion, 'nc'))
                    if (abs(predictionError) < obj.trainingParams.cParam2)
                        continue;
                    end
                end

                f_vector = Q_matrix*k_vector;

                predictionVar = obj.trainingParams.C + kernel_matrix(Xtr(n, :),obj.trainingParams.kernel_type, ...
                    obj.trainingParams.kernel_parameter,Xtr(n, :)) -...
                k_vector'*f_vector;
            
                if(strcmp(obj.trainingParams.criterion, 'sc'))
                    NC(n) = log(predictionVar)/2 + predictionError^2/(2*predictionVar);
                    if(NC(n) < obj.trainingParams.cParam1 || NC(n) > obj.trainingParams.cParam2)
                        continue;
                    end
                end
            
                %update Q_matrix
                s = 1/predictionVar;
                Q_tmp = zeros(dictSize+1,dictSize+1);
                Q_tmp(1:dictSize,1:dictSize) = Q_matrix + f_vector*f_vector'*s;
                Q_tmp(1:dictSize,dictSize+1) = -f_vector*s;
                Q_tmp(dictSize+1,1:dictSize) = Q_tmp(1:dictSize,dictSize+1)';
                Q_tmp(dictSize+1,dictSize+1) = s;
                Q_matrix = Q_tmp;

                % updating coefficients
                dictSize = dictSize + 1;
                obj.dictionaryIndex(dictSize) = n;
                obj.expansionCoefficient(dictSize) = s*predictionError;
                obj.expansionCoefficient(1:dictSize-1) = obj.expansionCoefficient(1:dictSize-1) ...
                    - f_vector'*obj.expansionCoefficient(dictSize);

                end
            end
        end

        function [labels, scores] = test(obj, Xts)
            
            N_test = size(Xts,1);
            scores = zeros(N_test, 1);
            
            if(strcmp(obj.trainingParams.criterion, 'fb') || strcmp(obj.trainingParams.criterion, 'ald'))
    
                if(strcmp(obj.trainingParams.criterion, 'fb'))
                    fcn = @km_fbkrls;
                elseif(strcmp(obj.trainingParams.criterion, 'ald'))
                    fcn = @km_aldkrls;
                end
                
                for i=1:N_test
                    scores(i) = fcn(obj.vars, obj.pars, Xts(i, :));
                end
                
            else

                for jj = 1:N_test
                    scores(jj) = obj.expansionCoefficient*...
                        kernel_matrix(Xts(jj,:),obj.trainingParams.kernel_type,obj.trainingParams.kernel_parameter, ...
                        obj.Xtr(obj.dictionaryIndex,:))';
                end
            end
            labels = convert_scores(scores, obj.getTask());
        end
        
        function res = isTaskAllowed(~, task)
            res = (task ~= Tasks.MC);
        end
    
    end
    
    methods(Static)
        function info = getInfo()
            info = ['Kernel Recursive Least-Square algorithm, including four sparsification criteria: ', ...
                'Novelty Criterion, Surprise Criterion, Approximate Linear Dependency and Fixed-Budget. ' ...
                'The last two criteria are implemented by calling the Kernel Methods Toolbox, which has to be installed on the system.' ...
                'For more information, refer to the book ''Kernel Adaptive Filtering'' by Principe et al.'];
        end
        
        function pNames = getParametersNames()
            pNames = {'kernel_type', 'kernel_parameter', 'C', 'maxIterations', 'criterion', 'cParam1', 'cParam2'}; 
        end
        
        function pInfo = getParametersInfo()
            pInfo = {'Kernel type', 'Kernel parameters', 'Regularization factor', 'Maximum number of iterations during training', 'Sparsification criterion', 'First parameter for sparsification', ...
                'Second parameter for sparsification'};
        end
        
        function pRange = getParametersRange()
            pRange = {'See help kernel_matrix, default is rbf', 'Vector of real numbers, see help kernel_matrix, default is 1', ...
                'Positive real number, default is 1', 'Natural number, default is Inf', 'String in {none, nc (Novelty), sc (Suprise), fb (Fixed Budget), ald (Approximate Linear Dependency)}', ...
                'Positive real number, default is 0', 'Positive real number, default is 0'};
        end 
    end
    
end

