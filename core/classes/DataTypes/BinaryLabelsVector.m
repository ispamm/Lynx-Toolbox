% BinaryLabelsVector - Vector of binary labels
%   This is a vector of binary labels (-1, +1) for binary classification

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef BinaryLabelsVector < DataType
    
    methods
        function obj = BinaryLabelsVector(data)
            obj = obj@DataType(data);
            assert(isnumeric(data) && size(data,2) == 1, 'Lynx:Validation:InvalidInput', 'Data must be a binary vector');
            assert(all(abs(data) == 1), 'Lynx:Validation:InvalidInput', 'All labels must be -1 or +1');
            obj.id = DataTypes.BINARY_LABEL_VECTOR;
        end
        
    end
    
    methods
        
        function [data1,data2] = partition(obj, idx1, idx2)
            data1 = BinaryLabelsVector(obj.data(idx1));
            data2 = BinaryLabelsVector(obj.data(idx2));
        end
        
        function data = shuffle(obj, shuff)
            data = BinaryLabelsVector(obj.data(shuff));
        end
        
        function s = getDescription(obj)
            s = sprintf('');
        end

    end
   
end

