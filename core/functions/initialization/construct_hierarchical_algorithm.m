% construct_hierarchical_algorithm - Construct a hierarchical learning
% algorithm (HLA) from previously defined algorithms. Only the resulting
% algorithm is kept in the simulation, while the others are deleted.
% The syntax is:
%
%   CONSTRUCT_HIERARCHICAL_ALGORITHM(ID, NAME, NARITIES, AGGREGATORS, IDS),
%   where ID and NAME are the identifier and name of the resulting
%   HLA. NARITIES is an N-dimensional vector denoting the number of
%   children of every node, in a depth-first fashion. Aggregators is a 
%   P-dimensional cell-array of Aggregator objects, where P is the number 
%   of non-terminal nodes. Each aggregator is used to partition data inside
%   a node. IDS is a cell array of N ids, corresponding to the learning 
%   algorithms of every node.
%
% As an example, suppose you have defined three algorithms, "A", "B", and
% "C". We want to construct the following tree:
%
%      A
%      |
%   -------
%   |     |
%   B     C
%
% and we want the values in A to be split according to whether they are
% greater or less than 0.5. This is achieved by the following call:
%
% construct_hierarchical_algorithm('H', 'HLA', [2 0 0],
% {RangeAggregator(0.5)}, {"A", "B", "C"});

function construct_hierarchical_algorithm(nArities, aggregators, algorithms_ids )

assert(sum(nArities > 0) == length(aggregators), 'Lynx:Runtime:HLA', 'The number of aggregators must be equal to the number of non-terminal nodes');
assert(length(nArities) == length(algorithms_ids), 'Lynx:Runtime:HLA',  'The number of algorithms must be equal to the number of nodes');

s = Simulation.getInstance();
currentAlgo = construct_recursively(nArities, aggregators, algorithms_ids);

for i = 1:length(algorithms_ids)
    s.algorithms = s.algorithms.remove(algorithms_ids{i});
end

s.algorithms = s.algorithms.addElement(currentAlgo);


    function [algo, nArities, aggregators, algorithms_ids] = ...
            construct_recursively(nArities, aggregators, algorithms_ids)
       
        algoStruct = s.algorithms.getById(algorithms_ids{1});
        if(nArities(1) > 0)
            algo = HierarchicalLearningAlgorithm(aggregators{1}, algoStruct);
            aggregators = aggregators(2:end);
        else
            algo = HierarchicalLearningAlgorithm([], algoStruct);
        end

        algorithms_ids = algorithms_ids(2:end);
        
        for j = 1:nArities(1)
           
            nArities = nArities(2:end);
            [algo_new, nArities, aggregators, algorithms_ids] = ...
                construct_recursively(nArities, aggregators, algorithms_ids);
            algo = algo.addChild(algo_new);
            
        end
        
    end

end
