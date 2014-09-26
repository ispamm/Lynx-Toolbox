% DEMO_DISTRIBUTED_SERIAL_G50C - Data-distributed RVFL (serial, g50c)

add_model('B', 'Baseline', @BaselineModel);
add_model('ELM', 'Centralized ELM', @ExtremeLearningMachine, 'hiddenNodes', 200);
add_model('LOC-ELM', 'Local ELM', @ExtremeLearningMachine, 'hiddenNodes', 200);
add_model('CONS-ELM', 'Distributed ELM (Consensus)', @ExtremeLearningMachine, 'hiddenNodes', 200);
add_model('ADMM-ELM', 'ADMM-ELM', @ExtremeLearningMachine, 'hiddenNodes', 200);

set_training_algorithm('ELM', @RegularizedELM, 'C', 0.01);
set_training_algorithm('LOC-ELM', @SerialDataDistributedRVFL, 'C', 10, 'consensus_max_steps', 0);
set_training_algorithm('CONS-ELM', @SerialDataDistributedRVFL, 'C', 10, 'consensus_max_steps', 250, 'consensus_thres', 0.01);
set_training_algorithm('ADMM-ELM', @SerialDataDistributedRVFL, 'C', 10, 'train_algo', 'admm', ...
    'consensus_max_steps', 250, 'admm_max_steps', 300, 'admm_rho', 1, 'admm_reltol', 0.001, 'admm_abstol', 0.001);

%add_wrapper('ELM', @ParameterSweep,  {'C', 'hiddenNodes'}, {2.^(-10:10), 50:50:1000});

add_dataset('G', 'G50C', 'g50c');

add_feature(SetSeedPRNG(1));

%add_feature(InitializeTopology(FullyConnectedTopology(30), 'disable_parallel', 'distribute_data', 'disable_plot'));
add_feature(InitializeTopology(RandomTopology(8, 0.2), 'disable_parallel', 'distribute_data', 'disable_plot'));
%add_feature(InitializeTopology(RandomTopology(30, 0.5), 'disable_parallel', 'distribute_data', 'disable_plot'));
%add_feature(InitializeTopology(LinearTopology(30, 1), 'disable_parallel', 'distribute_data', 'disable_plot'));
%add_feature(InitializeTopology(LinearTopology(30, 4), 'disable_parallel', 'distribute_data', 'disable_plot'));
%add_feature(InitializeTopology(SmallWorldTopology(30, 4, 0.25), 'disable_parallel', 'distribute_data', 'disable_plot'));
%add_feature(InitializeTopology(ScaleFreeTopology(30, 5, 3), 'disable_parallel', 'distribute_data', 'disable_plot'));

%add_feature(ExecuteOutputScripts('info_gridsearch'));
add_feature(ExecuteOutputScripts('info_distributedrvfl'));

%add_performance(Tasks.R, NormalizedRootMeanSquaredError(), true);
%add_performance(Tasks.BC, MatthewCorrelationCoefficient());
%add_performance(Tasks.BC, RocCurve());
%add_performance(Tasks.BC, PrecisionRecallCurve());
%add_performance(Tasks.BC, ConfusionMatrix());

set_partition_strategy(KFoldPartition(5));
set_runs(1);