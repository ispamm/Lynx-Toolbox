% NumericalContainer - A container for numerical values
%   Stores numerical values, and return their average as finalized
%   value. For displaying, provides a string with mean and standard
%   deviation of the values.
%
% See also: ValueContainer, FormatAsTable, OutputFormatter

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef NumericalContainer < ValueContainer
    
    properties
        valuesStd;
    end
    
    methods
        
        function obj = computeFinalizedValue(obj)
            obj.finalizedValue = mean(cell2mat(obj.storedValues));
            obj.valuesStd = std(cell2mat(obj.storedValues), 1);
        end
        
        function s = formatForOutput(obj)
            if(obj.isEmpty())
                s = 'NA';
            else
                obj = obj.checkForFinalizedValue();
                if(obj.valuesStd ~= 0)
                    s = sprintf('%.2f (+/- %.2f)', obj.getFinalizedValue(), obj.valuesStd);
                else
                    s = sprintf('%.2f', obj.getFinalizedValue());
                end
            end
        end
        
        function o = getDefaultOutputFormatter(obj)
            o = FormatAsTable();
        end
    end
    
end

