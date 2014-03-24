function set_partition_strategy( strategy )

%SET_PARTITION_STRATEGY Set the partitioning strategy for subdividing
%datasets. Example of usage:
%
%   SET_PARTITION_STRATEGY(HOLDOUT_PARTITION(0.3)) keeps 30% of data for
%   testing at every run.

    assert(isa(strategy, 'PartitionStrategy'), 'LearnToolbox:ValError:PartitionNotValid', 'The partitioning strategy is invalid');

    log = SimulationLogger.getInstance();
    log.setAdditionalParameter('partition_strategy', strategy);


end

