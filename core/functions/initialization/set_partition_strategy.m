
% set_partition_strategy - Set the partitioning strategy for subdividing
% datasets. Example of usage:
%
%   SET_PARTITION_STRATEGY(HOLDOUT_PARTITION(0.3)) keeps 30% of data for
%   testing at every run.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function set_partition_strategy( strategy )

    assert(isa(strategy, 'PartitionStrategy'), 'Lynx:ValError:PartitionNotValid', 'The partitioning strategy is invalid');

    log = Simulation.getInstance();
    log.partition_strategy =  strategy;


end

