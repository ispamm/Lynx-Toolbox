classdef DummyModel < Model
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    properties
        internalParameter;
    end
    
    methods
        
        function obj = DummyModel(id, name, varargin)
            obj = obj@Model(id, name, varargin{:});
        end
        
        function a = getDefaultTrainingAlgorithm(obj)
            a = DummyTrainingAlgorithm(obj);
        end
        
        function p = initParameters(~, p)
            p.addRequired('p_req');
            p.addOptional('p_opt', 1);
            p.addParamValue('p_pv', 3);
        end
        
        function [labels, scores] = test(obj, d)
            labels = obj.internalParameter + obj.parameters.p_req + (1:size(d.X.data, 1))';
            scores = labels;
        end
        
        function res = isDatasetAllowed(~, d)
            res = (d.task == Tasks.R || d.task == Tasks.BC || d.task == Tasks.MC);
        end
    end
    
    methods(Static)
        function info = getDescription()
            info = 'Dummymodel';
        end
        
    end
    
end

