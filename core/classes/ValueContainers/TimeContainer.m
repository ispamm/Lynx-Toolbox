% TimeContainer - Similar to NumericalContainer, but store only times
%
% See also: NumericalContainer

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef TimeContainer < NumericalContainer
    
    methods
        
        function obj = store(obj, value)
            obj = obj.store@NumericalContainer(value);
        end
        
        function s = formatForOutput(obj)
            if(obj.isEmpty())
                s = 'NA';
            else
                obj = obj.checkForFinalizedValue();
                s = sprintf('%.2f secs (+/- %.2f secs)', obj.getFinalizedValue(), obj.valuesStd);
            end
        end
    end
  
end

