% SubsetAggregator - Construct groups starting from subsets of the original classes
%
% Example:
%
% s = SubsetAggregator({2}, {3, 4});
% g = s.group([4 4 2 3])
% g = [2 2 1 2]

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef SubsetAggregator < Aggregator
    
    properties
        sets; % Cell array of groups
    end
   
    methods
        function obj = SubsetAggregator(varargin)
            for i = 1:nargin
                obj.sets{end+1} = varargin{i};
            end
        end
        
        function groups = group(obj, x)
            groups = zeros(length(x), 1);
            for i = 1:length(x)
                for j = 1:length(obj.sets)
                    if(any(x(i) == obj.sets{j}))
                        groups(i) = j;
                        break;
                    end
                end
            end
        end
        
        function s = getInfo(obj, id_group)
            if(length(obj.sets{id_group}) == 1)
                s = ['Class: ', mat2str(obj.sets{id_group})];
            else
                s = ['Classes: ', mat2str(obj.sets{id_group})];
            end
        end
    end
    
end

