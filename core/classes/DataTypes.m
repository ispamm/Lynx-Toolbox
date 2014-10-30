% DataTypes - List all the possible data types available

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef DataTypes < uint32
    
    enumeration
		% Input data types
        REAL_MATRIX     (1),  % Real matrix
        KERNEL_MATRIX   (2),  % Kernel matrix
        TIME_SERIES     (3),  % Time series
		
		% Output data types
		REAL_LABEL_VECTOR (4),   % Labels for regression
		BINARY_LABEL_VECTOR (5), % Labels for binary classification
		INTEGER_LABEL_VECTOR(6), % Labels for multiclass classification
		MULTILABEL_MATRIX(7)     % Labels for multilabel classification
    end
    
    methods
        function ind = subsindex(A)
            ind = uint32(A) - 1;
        end
    end
    
end