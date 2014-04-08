classdef Aggregator
    %AGGREGATOR An aggregator groups together the values of a vector. It is
    %used to subdivide data inside a node of a
    %HierarchicalLearningAlgorithm. Each group is identified by a natural
    %number in the set 1,...,M, where M is the total number of groups.
    %
    % Aggregator Methods:
    %
    %   group - Group a vector into classes.
    %   
    %   getInfo - Get information on the i-th group.
        
    
    methods(Abstract)
        groups = group(x);
        s = getInfo(id_group);
    end
    
end

