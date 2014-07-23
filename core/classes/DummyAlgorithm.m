classdef DummyAlgorithm < Baseline
    % This is used for constructing hierarchical learning algorithms (see
    % user manual)
    
    methods
        function obj = DummyAlgorithm(varargin)
                obj = obj@Baseline(varargin{:});
        end
        
        function p = initParameters(~, p)
            p.addParamValue('dummyParameter', 1);
        end
    end
    
end

