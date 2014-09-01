% XYPlotContainer - A container for XYPlot objects
%   The finalized value is a XYPlot containing the average of all the X-Y
%   values
%
% See also: XYPlot, ValueContainer

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef XYPlotContainer < ValueContainer
    
    methods
        
        function obj = store(obj, value)
            if(size(value.X, 2) == 1)
                value.X = (value.X)';
                value.Y = (value.Y)';
            end
            obj = obj.store@ValueContainer(value);
        end
        
        function obj = computeFinalizedValue(obj)
            obj.finalizedValue = obj.storedValues{1};
            for ii = 2:length(obj.storedValues)
                if(length(obj.finalizedValue.X) < length(obj.storedValues{ii}.X))
                    tmp = length(obj.storedValues{ii}.X) - length(obj.finalizedValue.X);
                    obj.finalizedValue.X = [zeros(1, tmp) obj.finalizedValue.X];
                    obj.finalizedValue.Y = [zeros(1, tmp) obj.finalizedValue.Y];
                elseif(length(obj.finalizedValue.X) > length(obj.storedValues{ii}.X))
                    tmp = - length(obj.storedValues{ii}.X) + length(obj.finalizedValue.X);
                    obj.storedValues{ii}.X = [zeros(1, tmp) obj.storedValues{ii}.X];
                    obj.storedValues{ii}.Y = [zeros(1, tmp) obj.storedValues{ii}.Y];
                end
                obj.finalizedValue.X = obj.finalizedValue.X + obj.storedValues{ii}.X;
                obj.finalizedValue.Y = obj.finalizedValue.Y + obj.storedValues{ii}.Y;
            end
            obj.finalizedValue.X = obj.finalizedValue.X ./ length(obj.storedValues);
            obj.finalizedValue.Y = obj.finalizedValue.Y ./ length(obj.storedValues);
            
            % Small hack for ROC curves
            if(length(obj.finalizedValue.X) == 2 && obj.finalizedValue.X(1) == 0 && obj.finalizedValue.Y(1) == 0)
                obj.finalizedValue.X = obj.finalizedValue.X(2);
                obj.finalizedValue.Y = obj.finalizedValue.Y(2);
            end
        end
        
        function s = formatForOutput(obj)
            s = obj.getFinalizedValue();
        end
        
        function o = getDefaultOutputFormatter(obj)
            o = FormatAsMultiplePlots();
        end
        
    end
    
end

