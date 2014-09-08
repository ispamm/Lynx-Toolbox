% DEMO_DISTRIBUTED - Demo with data-distributed algorithms

add_model('B', 'Baseline', @BaselineModel);
add_model('ELM', 'Centralized ELM', @ExtremeLearningMachine);
add_model('LOC-ELM', 'Local ELM', @ExtremeLearningMachine);
add_model('CONS-ELM', 'Distributed ELM (Consensus)', @ExtremeLearningMachine);
add_model('ADMM-ELM', 'Distributed ELM (ADMM)', @ExtremeLearningMachine);

set_training_algorithm('LOC-ELM', @DataDistributedRVFL, 'consensus_max_steps', 0);
set_training_algorithm('CONS-ELM', @DataDistributedRVFL, 'consensus_max_steps', 15);
set_training_algorithm('ADMM-ELM', @DataDistributedRVFL, 'train_algo', 'admm', 'consensus_max_steps', 15, 'admm_max_steps', 5);

add_dataset('G', 'G50C', 'g50c');

add_feature(DistributeData(RandomTopology(12, 0.2)));
add_feature(ExecuteOutputScripts('plot_consensus'));

set_runs(1);