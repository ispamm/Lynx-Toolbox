classdef RangeAggregator < Aggregator
    %RANGEAGGREGATOR A RangeAggregator groups values depending on a given 
    %set of intervals. Given values [a(1),...,a(n)], it provides N+1 
    %groups. The i-th group contains all values that are comprised in 
    %[a(i-1), a(i)]. The last group contains all values greated than a(n).
    
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
            elseif(id_group == length(obj.ranges))
                s = fprintf('y in [%.2f, Inf]', obj.ranges(end));
            else
                s = fprintf('y in [%.2f, %.2f]', obj.ranges(id_group-1), obj.ranges(id_group));
            end
        end
                
            
    end
    
end

