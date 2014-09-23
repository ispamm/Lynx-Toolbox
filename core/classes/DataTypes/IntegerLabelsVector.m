% IntegerLabelsVector - Vector of integer labels
%   This is a vector of integer labels (1,...,M) for multiclass 
%   classification.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef IntegerLabelsVector < DataType
    
    methods
        function obj = IntegerLabelsVector(data)
            obj = obj@DataType(data);
            assert(isnumeric(data) && size(data,2) == 1, 'Lynx:Validation:InvalidInput', 'Data must be an integer vector');
            assert(all(mod(data, 1) == 0), 'Lynx:Validation:InvalidInput', 'All labels must be integers');
            obj.id = DataTypes.INTEGER_LABEL_VECTOR;
        end
        
    end
    
    methods
        
        function [data1,data2] = partition(obj, idx1, idx2)
            data1 = IntegerLabelsVector(obj.data(idx1));
            data2 = IntegerLabelsVector(obj.data(idx2));
        end
        
        function data = shuffle(obj, shuff)
            data = IntegerLabelsVector(obj.data(shuff));
        end
        
        function s = getDescription(obj)
            s = sprintf('%i classes', max(obj.data));
        end

    end
   
end

