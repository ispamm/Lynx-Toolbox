% DEMO_DISTRIBUTED - Demo with data-distributed algorithms

%add_model('B', 'Baseline', @BaselineModel);
add_model('ELM', 'Centralized ELM', @ExtremeLearningMachine);
add_model('LOC-ELM', 'Local ELM', @ExtremeLearningMachine);
add_model('CONS-ELM', 'Distributed ELM (Consensus)', @ExtremeLearningMachine);
add_model('ADMM-ELM', 'Distributed ELM (ADMM)', @ExtremeLearningMachine);

set_training_algorithm('LOC-ELM', @DataDistributedRVFL, 'consensus_max_steps', 0);
set_training_algorithm('CONS-ELM', @DataDistributedRVFL, 'consensus_max_steps', 250);
set_training_algorithm('ADMM-ELM', @DataDistributedRVFL, 'train_algo', 'admm', 'consensus_max_steps', 100, ...
    'admm_rho', 1, 'admm_max_steps', 100);

%add_dataset('G', 'G50C', 'g50c');
add_dataset('S', 'Sylva', 'sylva ');

add_feature(SetSeedPRNG(1));
add_feature(DistributeData(RandomTopology(6, 0.2)));
add_feature(ExecuteOutputScripts('info_distributedrvfl'));

add_performance(Tasks.R, NormalizedRootMeanSquaredError(), true);
add_performance(Tasks.BC, RocCurve());
add_performance(Tasks.BC, PrecisionRecallCurve());
add_performance(Tasks.BC, ConfusionMatrix());

set_runs(15);