% MultiLabelMatrix - Matrix of labels
%   N x M matrix of labels, where N is the number of patterns and M the
%   number of labels. Each label can be +1 or -1.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef MultiLabelMatrix < DataType
    
    properties
        labels_info;
    end
    
    methods
        function obj = MultiLabelMatrix(data, labels_info)
            obj = obj@DataType(data);
            assert(isnumeric(data), 'Lynx:Validation:InvalidInput', 'Data must be a matrix');
            assert(all(abs(data(:)) == 1), 'Lynx:Validation:InvalidInput', 'All labels must be -1 or +1');
            obj.id = DataTypes.MULTILABEL_MATRIX;
            obj.labels_info = labels_info;
            obj.factory = BinaryRelevanceFactory();
        end
        
    end
    
    methods
        
        function [data1,data2] = partition(obj, idx1, idx2)
            data1 = MultiLabelMatrix(obj.data(idx1, :));
            data2 = MultiLabelMatrix(obj.data(idx2, :));
        end
        
        function data = shuffle(obj, shuff)
            data = MultiLabelMatrix(obj.data(shuff, :));
        end
        
        function s = getDescription(obj)
            s = sprintf('%i labels', size(obj.data, 2));
        end

    end
   
end

