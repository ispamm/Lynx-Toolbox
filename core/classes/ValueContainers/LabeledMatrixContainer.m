% LabeledMatrixContainer - A container for LabeledMatrix objects
%   The finalized value is a LabeledContainer object having the average
%   of all the matrices stored up to the current point.
%
% See also: LabeledMatrix, ValueContainer

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef LabeledMatrixContainer < ValueContainer
    
    methods
        
        function obj = storeValue(obj, value)
            obj = obj.storeValue@storeValue(value);
        end
        
        function obj = computeFinalizedValue(obj)
            obj.finalizedValue = obj.storedValues{1};
            for ii = 2:length(obj.storedValues)
                obj.finalizedValue.matrix = obj.finalizedValue.matrix + obj.storedValues{ii}.matrix;
            end
            obj.finalizedValue.matrix = obj.finalizedValue.matrix ./ length(obj.storedValues);
        end
        
        function s = formatForOutput(obj)
            s = obj.getFinalizedValue();
        end
        
        function o = getDefaultOutputFormatter(obj)
            o = FormatAsLabeledSequentialMatrices();
        end
        
    end
    
end

