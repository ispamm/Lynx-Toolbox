% ValueContainer - Store values and compute a finalized value (e.g. an average)
%   ValueContainer is a class for storing several values of a given
%   type, and computing a "finalized" value at the end (e.g. an
%   average).
%
% ValueContainer properties:
%   storedValues - Cell array of values stored up to the current point
%   finalizedValue - Finalized value (empty if not finalized yet)
%
% ValueContainer methods:
%   store - Store a value
%   getFinalizedValue - Obtain the finalized value
%   formatForOutput - Get the finalized value in a format suitable for
%   output

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef ValueContainer
    
    properties
        % Values stored up to the current point
        storedValues;
        % Finalized value (empty if not computed yet)
        finalizedValue;
    end
    
    methods(Abstract)
        % Return a format suitable for output
        s = formatForOutput(obj);
        % Compute the finalized value
        obj = computeFinalizedValue(obj);
        % Get the default OutputFormatter for this ValueContainer
        o = getDefaultOutputFormatter(obj);
    end
    
    methods
        
        function obj = ValueContainer()
            % Initialize the ValueContainer
            obj.storedValues = cell(0, 0);
            obj.finalizedValue = [];
        end
        
        function obj = store(obj, value)
            % Store a value
            obj.storedValues{end + 1} = value;
            obj.finalizedValue = [];
        end
        
        function p = getFinalizedValue(obj)
            % Compute and return the finalized value
            obj = obj.checkForFinalizedValue();
            p = obj.finalizedValue;
        end
        
        function b = isEmpty(obj)
            b = isempty(obj.storedValues);
        end
        
        function obj = checkForFinalizedValue(obj)
            % Compute the finalized value if it is not computed yet
            if(isempty(obj.finalizedValue))
                obj = obj.computeFinalizedValue();
            end
        end
        
        function obj = append(obj, v)
            for i = 1:length(v.storedValues)
                obj = obj.store(v.storedValues{i});
            end
        end
        
    end
    
end

