% FeatureScaling - Scales the features of the dataset in a predefined range
%   This has a single parameter:
%
%   add_preprocessor(id,
%   @FeatureScaling, 'range', [min,max]); scales the features in the range
%   [min, max]. Default is [-1, +1].

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef FeatureScaling < Preprocessor
    
    properties
        conf; % Precomputed scaling matrices
    end
    
    methods
        
        function obj = FeatureScaling(varargin)
            obj = obj@Preprocessor(varargin{:});
        end
        
        function p = initParameters(obj, p)
            p.addParamValue('range', [-1, +1], @(x) assert(length(x) == 2, 'Lynx:Validation:InvalidInput', 'Range of feature scaling must be a 2-dimensional vector'));
        end
        
        function [dataset, obj] = process( obj, dataset )
            [tmp, obj.conf] = mapminmax(dataset.X.data', obj.parameters.range(1), obj.parameters.range(2));
            dataset.X.data = tmp';
            fprintf('FeatureScaling: scaled dataset %s to [%.2f, %.2f]\n', dataset.name, obj.parameters.range(1), obj.parameters.range(2));
        end
        
        function dataset = processAsBefore(obj, dataset)
            tmp = mapminmax('apply', dataset.X.data', obj.conf);
            dataset.X.data = tmp';
        end
        
    end
    
    methods(Static)
        
        function info = getDescription()
            info = 'Scales the features in a predefined range';
        end
        
        function pNames = getParametersNames()
            pNames = {'range'};
        end
        
        function pInfo = getParametersDescription()
            pInfo = {'Range for scaling'};
        end
        
        function pRange = getParametersRange()
            pRange = {'Two-dimensional vector, default is [-1, +1]'};
        end
        
    end
    
end

