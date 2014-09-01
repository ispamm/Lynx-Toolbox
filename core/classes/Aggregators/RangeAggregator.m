% RangeAggregator - A RangeAggregator groups values depending on a given  set of intervals
%   Given values [a(1),...,a(n)], this provides N+1 groups. The i-th
%   group contains all values that are comprised in [a(i-1), a(i)]. The
%   last group contains all values greated than a(n).
%
%   Example:
%
%   >> r = RangeAggregator(0.5);
%   >> g = r.group([0.6 0.3 0.7])
%   g = [2 1 2]

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef RangeAggregator < Aggregator
    
    properties
        ranges; % Vector of split points
    end
   
    methods
        function obj = RangeAggregator(ranges)
            obj.ranges = ranges;
        end
        
        function groups = group(obj, x)
            groups = zeros(length(x), 1);
            for i = 1:length(obj.ranges)
                groups(x <= obj.ranges(i)) = i;
                x(x <= obj.ranges(i)) = Inf;
            end
            groups(groups == 0) = i + 1;
        end
        
        function s = getInfo(obj, id_group)
            if(id_group == 1)
                s = fprintf('y in [-Inf, %.2f]', obj.ranges(id_group));
            elseif(id_group == length(obj.ranges) + 1)
                s = fprintf('y in [%.2f, Inf]', obj.ranges(end));
            else
                s = fprintf('y in [%.2f, %.2f]', obj.ranges(id_group-1), obj.ranges(id_group));
            end
        end
                
            
    end
    
end

