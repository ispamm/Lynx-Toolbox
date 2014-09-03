% DataDistributedRVFL - 

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef DataDistributedRVFL < RegularizedELM
    
    properties
    end
    
    methods
        
        function obj = DataDistributedRVFL(model, varargin)
            obj = obj@RegularizedELM(model, varargin{:});
        end
        
        function obj = train_locally(obj, Xtr, Ytr)
            obj2 = RegularizedELM(obj);
            obj2 = obj2.train(Xtr, Ytr);
            obj.model = obj2.model;
        end

    end
    
end

