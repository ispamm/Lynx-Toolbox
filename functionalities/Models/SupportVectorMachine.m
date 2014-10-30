% SupportVectorMachine - Support Vector Machine for regression and binary classification
%   For binary and multiclass classification, this is a standard C-SVM,
%   while for regression this is a nu-SVM.
%
%   Parameters are:
%
%   C - Regularization parameter
%   kernel_type - Type of kernel function
%   kernel_para - Parameters of the kernel
%   nu - nu in nu-SVM.
%
%   For information on kernel_type and kernel_para, check the kernel_matrix
%   function.
%
%   Default training algorithm is LibSVM.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef SupportVectorMachine < Model
    
    properties
        support_vectors;
        coefficients;
        b;
    end
    
    methods
        
        function obj = SupportVectorMachine(id, name, varargin)
            obj = obj@Model(id, name, varargin{:});
        end
                
        function a = getDefaultTrainingAlgorithm(obj)
            a = MatlabSVM(obj);
        end
        
        function p = initParameters(~, p)
            p.addParamValue('C', 1, @(x) assert(x > 0, 'Regularization parameter of SVM must be > 0'));
            p.addParamValue('kernel_type', 'rbf', @(x) assert(ismember(x, {'rbf', 'lin', 'poly', 'wav', 'custom'}), 'Kernel type not recognized in SVM'));
            p.addParamValue('kernel_para', 1);
            p.addParamValue('nu', 0.1);
        end
        
        function [labels, scores] = test(obj, d)
            % TODO
        end
        
        function res = isDatasetAllowed(~, d)
            res = d.task == Tasks.R || d.task == Tasks.BC;
            res = res && (d.X.id == DataTypes.REAL_MATRIX || d.X.id == DataTypes.KERNEL_MATRIX);
        end
    
    end
    
    methods(Static)
        function info = getDescription()
            info = 'Support Vector Machine, C-SVM for binary classification and nu-SVM for regression.';
        end
        
        function pNames = getParametersNames()
            pNames = {'C', 'kernel_type', 'kernel_para', 'nu'}; 
        end
        
        function pInfo = getParametersDescription()
            pInfo = {'Regularization factor', 'Kernel function', 'Kernel parameters', 'Nu parameter in nu-SVM'};
        end
        
        function pRange = getParametersRange()
            pRange = {'Positive real number, default is 1', 'String in {rbf, lin, poly, wav, custom}, default is rbf', 'Real number, default is 1', ...
                'Real number in [0, 1], default is 0.1'};
        end 
    end
    
end

