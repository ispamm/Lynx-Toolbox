% RealMatrix - Matrix of real vectors
%   This is the basic input type for algorithms working with real-valued
%   vectors. Each row is an example, while each column is a feature.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef RealMatrix < DataType
   
    
    methods
        function obj = RealMatrix(data)
            obj = obj@DataType(data);
            assert(isnumeric(data), 'Lynx:Validation:InvalidInput', 'Data must be a real matrix');
            obj.id = DataTypes.REAL_MATRIX;
        end
        
    end
    
    methods
        
        function [data1,data2] = partition(obj, idx1, idx2)
            data1 = RealMatrix(obj.data(idx1,:));
            data2 = RealMatrix(obj.data(idx2,:));
        end
        
        function data = shuffle(obj, shuff)
            data = RealMatrix(obj.data(shuff,:));
        end
        
        function s = getDescription(obj)
            s = sprintf('%i examples, %i features', size(obj.data, 1), size(obj.data, 2));
        end

    end
   
end

