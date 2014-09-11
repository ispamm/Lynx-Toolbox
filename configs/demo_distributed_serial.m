% DEMO_DISTRIBUTED_SERIAL - Demo with data-distributed algorithms (serial version)

%add_model('B', 'Baseline', @BaselineModel);
add_model('ELM', 'Centralized ELM', @ExtremeLearningMachine, 'hiddenNodes', 200);
add_model('LOC-ELM', 'Local ELM', @ExtremeLearningMachine, 'hiddenNodes', 200);
add_model('CONS-ELM', 'Distributed ELM (Consensus)', @ExtremeLearningMachine, 'hiddenNodes', 200);
add_model('ADMM-ELM', 'ADMM-ELM', @ExtremeLearningMachine, 'hiddenNodes', 200);

set_training_algorithm('LOC-ELM', @SerialDataDistributedRVFL, 'C', 0.1, 'consensus_max_steps', 0);
set_training_algorithm('CONS-ELM', @SerialDataDistributedRVFL, 'C', 0.1, 'consensus_max_steps', 250);
set_training_algorithm('ADMM-ELM', @SerialDataDistributedRVFL, 'C', 0.1, 'train_algo', 'admm', ...
    'consensus_max_steps', 250, 'admm_max_steps', 250, 'admm_rho', 0.5, 'admm_reltol', 0.001, 'admm_abstol', 0.001);

%add_dataset('G', 'G50C', 'g50c');
add_dataset('G', 'Garageband', 'garageband');
%add_dataset('S', 'Sylva', 'sylva ');

add_feature(SetSeedPRNG(1));

add_feature(InitializeTopology(RandomTopology(25, 0.2), 'disable_parallel', 'distribute_data'));

add_feature(ExecuteOutputScripts('info_distributedrvfl'));

add_performance(Tasks.R, NormalizedRootMeanSquaredError(), true);
add_performance(Tasks.BC, RocCurve());
add_performance(Tasks.BC, PrecisionRecallCurve());
add_performance(Tasks.BC, ConfusionMatrix());

set_runs(1);