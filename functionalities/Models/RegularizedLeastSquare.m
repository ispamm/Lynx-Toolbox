% RegularizedLeastSquare - Regularized Least Square model
%   For more information, please refer to the following paper:
%
%   [1] Evgeniou, Theodoros, Massimiliano Pontil, and Tomaso Poggio.
%   "Regularization networks and support vector machines." Advances in
%   Computational Mathematics 13.1 (2000): 1-50.
%
%   Two possible parameters are:
%
%   kernel_type - Type of kernel function
%   kernel_para - Parameters of the kernel
%
%   For information on these two parameters, check the kernel_matrix
%   function.
%
%   The this parameter is 'C', the regularization factor.
%
%   Default training algorithm is StandardRLS.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it
    

classdef RegularizedLeastSquare < Model
    
    properties
        Xtr;
        outputWeights;
    end
    
    methods
        
        function obj = RegularizedLeastSquare(id, name, varargin)
            obj = obj@Model(id, name, varargin{:});
        end
        
        function p = initParameters(~, p)
            p.addParamValue('kernel_type', 'rbf', @(x) assert(ischar('x'), 'Kernel type must be a string'));
            p.addParamValue('kernel_para', 1);
            p.addParamValue('C', 1, @(x) assert(x > 0, 'Regularization parameter of RN must be > 0'));
        end
        
        function [labels, scores] = test(obj, d)
            
            % Get training data
            Xts = d.X.data;
            
            if(isempty(obj.outputWeights))
                scores = zeros(size(Xts, 1), 1);
            else
                if(strcmp(obj.parameters.kernel_type, 'custom'))
                    Omega_test = Xts';
                else
                    Omega_test = kernel_matrix(obj.Xtr,obj.parameters.kernel_type, obj.parameters.kernel_para, Xts);
                end
                scores = (Omega_test' * obj.outputWeights);
            end
            labels = convert_scores(scores, d.task);
        end
        
        function res = isDatasetAllowed(~, d)
            res = d.task == Tasks.R || d.task == Tasks.BC || d.task == Tasks.MC;
            res = res && (d.X.id == DataTypes.REAL_MATRIX || d.X.id == DataTypes.KERNEL_MATRIX);
        end
        
        function a = getDefaultTrainingAlgorithm(obj)
            a = StandardRLS(obj);
        end
    end
    
    methods(Static)
        function info = getDescription()
            info = 'Regularized Least-Square model. For more information, please refer to the following paper: Evgeniou, Theodoros, Massimiliano Pontil, and Tomaso Poggio. "Regularization networks and support vector machines." Advances in Computational Mathematics 13.1 (2000): 1-50.';
        end
        
        function pNames = getParametersNames()
            pNames = {'kernel_type', 'kernel_para', 'C'}; 
        end
        
        function pInfo = getParametersDescription()
            pInfo = {'Kernel function', 'Kernel parameters', 'Regularization factor'};
        end
        
        function pRange = getParametersRange()
            pRange = {'See help kernel_matrix, default is rbf', 'Vector of real numbers, see help kernel_matrix, default is 1', 'Positive real number, default is 1'};
        end  
    end
    
end

