% PercentageContainer - Similar to NumericalContainer, but store only percentages
%
% See also: NumericalContainer

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef PercentageContainer < NumericalContainer
    
    methods
        
        function obj = store(obj, value)
            assert(isinrange(value), 'Lynx:Validation:InvalidInput', 'Values in a PercentageContainer must be in the range [0,1]');
            obj = obj.store@NumericalContainer(value);
        end
        
        function s = formatForOutput(obj)
            if(obj.isEmpty())
                s = 'NA';
            else
                obj = obj.checkForFinalizedValue();
                s = sprintf('%.2f%% (+/- %.2f%%)', obj.getFinalizedValue()*100, obj.valuesStd*100);
            end
        end
    end
    
end
