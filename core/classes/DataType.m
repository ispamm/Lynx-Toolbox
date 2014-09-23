% DataType - A possible data type for learning
%   Examples of this are: RealMatrix, BinaryLabelsVector, etc.
%   It provides a method for partitioning the set of data according to some
%   given indices, to shuffle the data, and to get a description.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef DataType
    
    properties
        id;             % The ID of the type
        data;           % The actual data
        factory;        % Default factory
    end
    
    methods
        function obj = DataType(data)
            % Construct the InputType object
            obj.data = data;
            obj.factory = DummyDatasetFactory(); % Default choice
        end
        
    end
    
    methods(Abstract)
        % Partition the data according to the given indices
        [data1, data2] = partition(obj, idx1, idx2);
        % Shuffle the data
        data = shuffle(obj, shuff);
        % Get a description
        s = getDescription(obj);
    end
    
    methods
        function f = getDefaultFactory(obj)
            % Get the default dataset factory
            f = obj.factory;
        end
    end
   
end

