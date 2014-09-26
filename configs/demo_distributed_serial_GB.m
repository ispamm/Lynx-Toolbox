% DEMO_DISTRIBUTED_SERIAL_GB - Demo with data-distributed algorithms (serial version)

%add_model('B', 'Baseline', @BaselineModel);
add_model('ELM', 'Centralized ELM', @ExtremeLearningMachine, 'hiddenNodes', 200);
add_model('LOC-ELM', 'Local ELM', @ExtremeLearningMachine, 'hiddenNodes', 200);
add_model('CONS-ELM', 'Distributed ELM (Consensus)', @ExtremeLearningMachine, 'hiddenNodes', 200);
add_model('ADMM-ELM', 'ADMM-ELM', @ExtremeLearningMachine, 'hiddenNodes', 200);

set_training_algorithm('ELM', @RegularizedELM, 'C', 8);
set_training_algorithm('LOC-ELM', @SerialDataDistributedRVFL, 'C', 1/8, 'consensus_max_steps', 0);
set_training_algorithm('CONS-ELM', @SerialDataDistributedRVFL, 'C', 1/8, 'consensus_max_steps', 250);
set_training_algorithm('ADMM-ELM', @SerialDataDistributedRVFL, 'C', 1/8, 'train_algo', 'admm', ...
    'consensus_max_steps', 250, 'admm_max_steps', 300, 'admm_rho', 1, 'admm_reltol', 0.001, 'admm_abstol', 0.001);

add_dataset('G', 'Garageband', 'garageband');

add_feature(SetSeedPRNG(1));

add_feature(InitializeTopology(LinearTopology(30, 1), 'disable_parallel', 'distribute_data', 'disable_plot'));

add_feature(ExecuteOutputScripts('info_distributedrvfl'));

add_performance(Tasks.R, NormalizedRootMeanSquaredError(), true);
add_performance(Tasks.BC, RocCurve());
add_performance(Tasks.BC, PrecisionRecallCurve());
add_performance(Tasks.BC, ConfusionMatrix());

set_partition_strategy(KFoldPartition(5));
set_runs(1);