% NoAggregator - Do not aggregate data (dummy object)

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef NoAggregator < Aggregator

    methods
        function obj = NoAggregator()
        end
        
        function groups = group(~, x)
            groups = x;
        end
        
        function s = getInfo(~, ~)
            s = '';
        end
                
            
    end
    
end

