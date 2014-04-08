classdef SubsetAggregator < Aggregator
    %SUBSETAGGREGATOR A SubsetAggregator construct groups starting from
    %subsets of the original classes.
    
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

