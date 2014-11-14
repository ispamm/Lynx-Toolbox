% OnlineRLS - Online RLS model
%   This is trained using a Recursive Least-Square procedure. It is
%   equivalent to the Kernel Recursive Least-Square algorithm:
%
%   [1] Liu, W., Principe, J. C., & Haykin, S. (2011). Kernel Adaptive
%   Filtering: A Comprehensive Introduction (Vol. 57). John Wiley & Sons.
%
%   It has four internal parameters:
%
%   max_iterations - The maximum number of examples that will be processed
%   sparsification_criterion - The criterion to sparsify the model. It can
%       'none' (no criterion), 'fb' (fixed budget), 'sc' (suprise), 'nc'
%       (novelty) or 'ald' (approximate linear dependency). For a
%       description of the fb criterion, refer to:
%
%   [2] Van Vaerenbergh, S., Santamaria, I., Liu, W., & Principe, J. C.
%   (2010, March). Fixed-budget kernel recursive least-squares. In
%   Acoustics Speech and Signal Processing (ICASSP), 2010 IEEE
%   International Conference on (pp. 1882-1885). IEEE.
%
%   cParam1, cParam2: the parameters of the sparsification criteria.
%
%   The fb and ald criterion are implemented using the Kernel Methods
%   toolbox.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef OnlineRLS < LearningAlgorithm
    
    properties
        vars;
        pars;
    end
    
    methods
        
        function obj = OnlineRLS(model, varargin)
            obj = obj@LearningAlgorithm(model, varargin{:});
        end
        
        function p = initParameters(~, p)
            p.addParamValue('max_iterations', Inf);
            p.addParamValue('sparsification_criterion', 'none', @(x) isingroup(x, {'none', 'ald', 'fb', 'sc', 'nc'}));
            p.addParamValue('cParam1', 0);
            p.addParamValue('cParam2', 0);
        end
        
        function obj = train(obj, d)
            
            % Get training data
            Xtr = d.X.data;
            Ytr = d.Y.data;
            
            obj.model.Xtr = Xtr;
            [N, ~] = size(Xtr);
            
            if(obj.parameters.max_iterations > N)
                stoppingIteration = N;
            else
                stoppingIteration = obj.parameters.max_iterations;
            end
            
            if(strcmp(obj.parameters.sparsification_criterion, 'fb') || strcmp(obj.parameters.sparsification_criterion, 'ald'))
                
                if(strcmp(obj.parameters.sparsification_criterion, 'fb'))
                    obj.pars.algo = 'fb-krls';
                    obj.pars.M = obj.parameters.cParam1;
                elseif(strcmp(obj.parameters.sparsification_criterion, 'ald'))
                    obj.pars.algo = 'ald-krls';
                    obj.pars.thresh = obj.parameters.cParam1;
                end
                
                obj.pars.c = obj.getParameter('C');
                obj.pars.kernel.type = obj.getKernelType();
                if(strcmp(obj.pars.kernel.type, 'gauss'))
                    obj.pars.kernel.par = sqrt(1/(2*obj.getParameter('kernel_para')));
                end
                
                obj.pars.mu = 0;
                
                
                if(strcmp(obj.parameters.sparsification_criterion, 'fb'))
                    fcn = @km_fbkrls;
                elseif(strcmp(obj.parameters.sparsification_criterion, 'ald'))
                    fcn = @km_aldkrls;
                end
                
                for i=1:stoppingIteration
                    
                    obj.vars.t = i;
                    obj.vars = fcn(obj.vars, obj.pars, Xtr(i,:), Ytr(i));
                    
                end
                
                obj.model.Xtr = obj.vars.mem;
                obj.model.outputWeights = obj.vars.alpha;
                
            else
                
                Q_matrix = 1/(obj.getParameter('C') + kernel_matrix(Xtr(1, :), obj.getParameter('kernel_type'), ...
                    obj.getParameter('kernel_para'), Xtr(1, :)));
                expansionCoefficient = Q_matrix*Ytr(1);
                
                NC = zeros(1, N);
                
                % dictionary
                dictionaryIndex = 1;
                dictSize = 1;
                
                for n = 2:stoppingIteration
                    
                    if(strcmp(obj.parameters.sparsification_criterion, 'nc'))
                        
                        distance2dictionary = min(sum((repmat(Xtr(n,:), dictSize, 1) - Xtr(dictionaryIndex,:)).^2, 2));
                        if (distance2dictionary < obj.parameters.cParam1)
                            continue;
                        end
                        
                    end
                    
                    k_vector = kernel_matrix(Xtr(n,:), obj.getParameter('kernel_type'), ...
                        obj.getParameter('kernel_para'), Xtr(dictionaryIndex, :));
                    k_vector = k_vector';
                    networkOutput = expansionCoefficient*k_vector;
                    predictionError = Ytr(n) - networkOutput;
                    
                    if(strcmp(obj.parameters.sparsification_criterion, 'nc'))
                        if (abs(predictionError) < obj.parameters.cParam2)
                            continue;
                        end
                    end
                    
                    f_vector = Q_matrix*k_vector;
                    
                    predictionVar = obj.getParameter('C') + kernel_matrix(Xtr(n, :),obj.getParameter('kernel_type'), ...
                        obj.getParameter('kernel_para'), Xtr(n, :)) -...
                        k_vector'*f_vector;
                    
                    if(strcmp(obj.parameters.sparsification_criterion, 'sc'))
                        NC(n) = log(predictionVar)/2 + predictionError^2/(2*predictionVar);
                        if(NC(n) < obj.parameters.cParam1 || NC(n) > obj.parameters.cParam2)
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
                    dictionaryIndex(dictSize) = n;
                    expansionCoefficient(dictSize) = s*predictionError;
                    expansionCoefficient(1:dictSize-1) = expansionCoefficient(1:dictSize-1) ...
                        - f_vector'*expansionCoefficient(dictSize);
                    
                end
                
                obj.model.Xtr = Xtr(dictionaryIndex, :);
                obj.model.outputWeights = expansionCoefficient';
                
            end
        end

        function res = isDatasetAllowed(obj, d)
            res = d.task == Tasks.R || d.task == Tasks.BC;
            res = res && obj.model.isDatasetAllowed(d);
        end
        
        function b = checkForCompatibility(~, model)
            b = model.isOfClass('RegularizedLeastSquare');
        end
        
        function b = checkForPrerequisites(obj)
            b = LibraryHandler.checkAndInstallLibrary('km_box', 'Kernel Methods Toolbox', ...
                'http://downloads.sourceforge.net/project/kmbox/KMBOX-0.9.zip', 'OnlineRLS training algorithm');
        end
        
        
    end
    
       methods(Access=private)
        function s = getKernelType(obj)
            % Convert the kernel_type parameter into the corresponding
            % string in the KM toolbox
            switch obj.getParameter('kernel_type')
                case 'rbf'
                    s = 'gauss';
                case 'poly'
                    s = 'poly';
                case 'lin'
                    s = 'linear';
                otherwise
                    error('Lynx:Runtime:InvalidKernelType', 'The OnlineRLS training algorithm does not support the chosen kernel type');
            end
        end
    end
    
    methods(Static)
        function info = getDescription()
            info = 'RLS trained using a Recursive Least-Squares approach. For more information, please refer to the help of the class.';
        end
        
        function pNames = getParametersNames()
            pNames = {'max_iterations', 'sparsification_criterion', 'cParam1', 'cParam2'};
        end
        
        function pInfo = getParametersDescription()
            pInfo = {'Maximum number of iterations', 'Sparsification criterion', 'First parameter of the sparsification criterion', ...
                'Second parameter of the sparsification criterion'};
        end
        
        function pRange = getParametersRange()
            pRange = {'Integer (default Inf)', 'String in {none, ald, sc, nc, fb}, default none', ...
                'Depends on the sparsification criterion', 'Depends on the sparsification criterion'};
        end
    end
    
end

