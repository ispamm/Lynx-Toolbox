% PrincipalComponentAnalysis - Applies a Principal Component Analysis to the dataset
%   This has a single parameter:
%
%   add_preprocessor(id,
%   @PrincipalComponentAnalysis, 'varianceToPreserve', p); change the
%   percentage of variance to preserve.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef PrincipalComponentAnalysis < Preprocessor
    
    properties
        prinComps; % Computed principal components
        mu;        % Computed mean
    end
    
    methods
        
        function obj = PrincipalComponentAnalysis(varargin)
            obj = obj@Preprocessor(varargin{:});
        end
        
        function p = initParameters(obj, p)
            p.addParamValue('varianceToPreserve', 0.95, @(x) assert(isinrange(x), 'Lynx:Validation:InvalidInput', 'Variance of PrincipalComponentAnalysis must be in [0,1]'));
        end
        
        function [dataset, obj] = process( obj, dataset )
            originalSize = size(dataset.X.data, 2);
            [obj.prinComps, dataset.X.data, ~, ~, explained, obj.mu] = pca(dataset.X.data);
            explained = round(cumsum(explained));
            idx = explained <= obj.parameters.varianceToPreserve*100;
            dataset.X.data = dataset.X.data(:, idx);
            obj.prinComps = obj.prinComps(:, idx);
            fprintf('PCA: extracted %i out of %i principal components in dataset %s\n', sum(idx), originalSize, dataset.name);
        end
        
        function dataset = processAsBefore(obj, dataset)
            dataset.X.data = dataset.X.data - repmat(obj.mu, size(dataset.X.data, 1), 1);
            dataset.X.data = dataset.X.data*obj.prinComps;
        end
        
    end
    
    methods(Static)
        
        function info = getDescription()
            info = 'Apply a Principal Component Analysis to the dataset';
        end
        
        function pNames = getParametersNames()
            pNames = {'varianceToPreserve'};
        end
        
        function pInfo = getParametersDescription()
            pInfo = {'Percentage of variance to keep into the transformed dataset'};
        end
        
        function pRange = getParametersRange()
            pRange = {'[0,1], default is 0.95'};
        end
        
    end
    
end

