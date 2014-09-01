% Aggregator - Groups together the values of a vector
%
%   Mathematically, an aggregator is a function (R)^N -> (1,...,M)^N, i.e.,
%   it associates to every value of an N-dimensional real vector, an 
%   integer between 1 and M, where M is the number of groups.
%
%   An Aggregator object is used to subdivide data inside a node of a
%   HierarchicalLearningAlgorithm. In there, every group represents a child
%   of the current node where to send the particular input vector.
%
% Aggregator Methods:
%
%   group - Group a vector into classes.
%   getInfo - Get information on the i-th group.

classdef Aggregator
    
    methods(Abstract)
        % Group together elements
        groups = group(x);
        % Get information on the i-th group
        s = getInfo(id_group);
    end
    
end

