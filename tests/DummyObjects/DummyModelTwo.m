classdef DummyModelTwo < Model
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    methods
        
        function obj = DummyModelTwo(id, name, varargin)
            obj = obj@Model(id, name, varargin{:});
        end
        
        function a = getDefaultTrainingAlgorithm(obj)
            a = DummyTrainingAlgorithm(obj);
        end
        
        function p = initParameters(~, p)
        end
        
        function [labels, scores] = test(obj, Xts)
        end
        
        function res = isTaskAllowed(~, t)
        end
    end
    
    methods(Static)
        function info = getDescription()
            info = 'Dummymodeltwo';
        end
        
    end
    
end

