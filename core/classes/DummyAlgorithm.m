classdef DummyAlgorithm < Baseline
    % This is used for constructing hierarchical learning algorithms (see
    % user manual)
    
    methods
        function obj = DummyAlgorithm(varargin)
                obj = obj@Baseline({});
        end
    end
    
end

