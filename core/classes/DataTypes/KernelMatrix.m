% KernelMatrix - A precomputed kernel matrix
%   This can be used with kernel methods accepting a custom kernel matrix.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef KernelMatrix < DataType
   
    
    methods
        function obj = KernelMatrix(data)
            obj = obj@DataType(data);
            assert(isnumeric(data), 'Lynx:Validation:InvalidInput', 'Data must be a real matrix');
            assert(size(data,1) == size(data,2), 'Lynx:Validation:InvalidInput', 'Data must be a square matrix');
            obj.id = DataTypes.KERNEL_MATRIX;
        end
        
    end
    
    methods
        
        function [data1,data2] = partition(obj, idx1, idx2)
            data1 = KernelMatrix(obj.data(idx1,idx1));
            data2 = KernelMatrix(obj.data(idx2,idx1));
        end
        
        function data = shuffle(obj, shuff)
            data = obj;
        end
        
        function s = getDescription(obj)
            s = sprintf('Kernel matrix with %i examples', size(obj.data, 1));
        end
        
    end
   
end

