% AddNoise - Add noise to the inputs
%   Currently, this only handles Gaussian noise on all inputs, with
%   variance set as follows:
%
%   add_preprocessor(id,
%   @AddNoise, 'variance', v);

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef AddNoise < Preprocessor
    
    properties
    end
    
    methods
        
        function obj = AddNoise(varargin)
            obj = obj@Preprocessor(varargin{:});
        end
        
        function p = initParameters(obj, p)
            p.addParamValue('variance', 0.01);
        end
        
        function [dataset, obj] = process( obj, dataset )
            [N, d] = size(dataset.X);
            noise = randn(N, d).*sqrt(obj.parameters.variance);
            dataset.X = dataset.X + noise;
        end
        
        function dataset = processAsBefore(obj, dataset)
            dataset = obj.process(dataset);
        end
        
    end
    
    methods(Static)
        
        function info = getDescription()
            info = 'Add noise to the inputs';
        end
        
        function pNames = getParametersNames()
            pNames = {'variance'};
        end
        
        function pInfo = getParametersDescription()
            pInfo = {'Variance of the Guassian noise'};
        end
        
        function pRange = getParametersRange()
            pRange = {'Positive real number, default to 0.01'};
        end
        
    end
    
end

