% RealLabelsVector - Vector of real labels
%   This is a vector of real labels for regression.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef RealLabelsVector < DataType
   
    
    methods
        function obj = RealLabelsVector(data)
            obj = obj@DataType(data);
            assert(isnumeric(data) && size(data,2) == 1, 'Lynx:Validation:InvalidInput', 'Data must be a real vector');
            obj.id = DataTypes.REAL_LABEL_VECTOR;
        end
        
    end
    
    methods
        
        function [data1,data2] = partition(obj, idx1, idx2)
            data1 = RealLabelsVector(obj.data(idx1));
            data2 = RealLabelsVector(obj.data(idx2));
        end
        
        function data = shuffle(obj, shuff)
            data = RealLabelsVector(obj.data(shuff));
        end
        
        function s = getDescription(obj)
            s = sprintf('');
        end

    end
   
end

