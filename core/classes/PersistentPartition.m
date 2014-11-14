% PersistentPartition - Persistent partition strategy
%   A persistent partition strategy can be used to construct equal
%   partitions across multiple wrappers. First, you can create a persistent
%   partition by providing a given PartitionStrategy:
%
%       p = PersistentPartition(KFoldPartition(3));
%
%   Then, you can assign it to multiple wrappers:
%
%       add_wrapper('A', @ParameterSweep, ..., 'partition_strategy', p);
%       add_wrapper('B', @ParameterSweep, ..., 'partition_strategy', p);
%
%   In this way, both wrappers for algorithms A and B will use the exact
%   same partition. This ensures perfect fairness during the simulations.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef PersistentPartition < handle
    
    properties
        p;                  % Internal partition strategy
        computedPartitions; % A map of computed partitions
    end
    
    methods
        function obj = PersistentPartition(p)
            assert(isa(p, 'PartitionStrategy'), 'Lynx:Validation:InvalidParameter', 'The argument of PersistentPartition must be a PartitionStrategy');
            obj.p = p;
            obj.computedPartitions = containers.Map;
        end
    
        function p_res = partition(obj, Y)
            % PersistentPartition keeps track of already computed
            % partitions by means of an hash function
           hash = DataHash(Y); 
           if(obj.computedPartitions.isKey(hash))
               p_res = obj.computedPartitions(hash);
           else
              p_res = obj.p.partition(Y);
              obj.computedPartitions(hash) = p_res;
          end
        end

        function trainIndexes = getTrainingIndexes(obj)
            error('Lynx:Runtime:PersistentPartition', 'You cannot call getTrainingIndexes on a PersistentPartition object');
        end
              
        function testIndexes = getTestIndexes(obj)
            error('Lynx:Runtime:PersistentPartition', 'You cannot call getTestIndexes on a PersistentPartition object');
        end
        
        function s = getFoldInformation(obj)
            error('Lynx:Runtime:PersistentPartition', 'You cannot call getFoldInformation on a PersistentPartition object');
        end
        

    end
    
end

