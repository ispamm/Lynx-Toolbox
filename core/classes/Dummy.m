% Dummy - Dummy object for a HierarchicalLearningAlgorithm
%   This is used for constructing hierarchical learning algorithms (see
%   user manual)

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef Dummy < BaselineTrainingAlgorithm
    
    methods
        function obj = Dummy(varargin)
        	obj = obj@BaselineTrainingAlgorithm(varargin{:});
        end
        
        function p = initParameters(~, p)
        end
    end
    
end

