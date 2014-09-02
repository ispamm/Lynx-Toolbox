% Subsampler - Subsample dataset by a given percentage
%   This has a single parameter:
%
%   add_preprocessor(id,
%   @Subsampler, 'percentage', d); subsample by a percentage d

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef Subsampler < Preprocessor
    
    properties
    end
    
    methods
        
        function obj = Subsampler(varargin)
            obj = obj@Preprocessor(varargin{:});
        end
        
        function p = initParameters(obj, p)
            p.addParamValue('d', 0.5, @(x) assert(isinrange(x), 'Lynx:Validation:InvalidInput', 'Percentage d of Subsampler must be in [0,1]'));
        end
        
        function [dataset, obj] = process( obj, dataset )
            N = size(dataset.X,1);
            if(dataset.task == Tasks.R || dataset.task == Tasks.BC || dataset.task == Tasks.MC || dataset.task == Tasks.ML)
                cv = cvpartition(N, 'Holdout', obj.parameters.d);
                dataset.X = dataset.X(test(cv),:);
                dataset.Y = dataset.Y(test(cv),:);
            elseif(dataset.task == Tasks.PR)
                splitPoint = floor(obj.parameters.d*length(dataset.X));
                dataset.X = dataset.X(1:splitPoint);
            end
            fprintf('Subsampled original dataset of %i elements to %i\n', N, size(dataset.X, 1));
        end
        
        function dataset = processAsBefore(obj, dataset)
            dataset = obj.process(dataset);
        end
        
    end
    
    methods(Static)
        
        function info = getDescription()
            info = 'Subsample the data by a given percentage';
        end
        
        function pNames = getParametersNames()
            pNames = {'d'};
        end
        
        function pInfo = getParametersDescription()
            pInfo = {'Percentage of dataset to keep'};
        end
        
        function pRange = getParametersRange()
            pRange = {'[0,1], default is 0.5'};
        end
        
    end
    
end

