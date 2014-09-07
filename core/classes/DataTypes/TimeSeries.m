% TimeSeries - Time-series object

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef TimeSeries < DataType
   
    
    methods
        function obj = TimeSeries(data)
            obj = obj@DataType(data);
            assert(size(data, 2) == 1, 'Lynx:Validation:InvalidInput', 'Data must be a real vector');
            obj.id = DataTypes.TIME_SERIES;
            obj.factory = EmbedTimeseriesFactory(7, 1);
        end
        
    end
    
    methods
        
        function [data1,data2] = partition(obj, idx1, idx2)
            error('Lynx:Runtime:Logical', 'Cannot currently partition time series');
        end
        
        function data = shuffle(obj, shuff)
            data = obj;
        end
        
        % Get a description
        function s = getDescription(obj)
            s = sprintf('Time series with %i samples', length(obj.data));
        end
        
    end
   
end

