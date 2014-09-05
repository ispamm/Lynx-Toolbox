% DEMO_DISTRIBUTED - Demo with data-distributed algorithms

add_model('ELM', 'Centralized ELM', @ExtremeLearningMachine);
add_model('LOC-ELM', 'Local ELM', @ExtremeLearningMachine);
add_model('CONS-ELM', 'Distributed ELM (Consensus)', @ExtremeLearningMachine);
add_model('ADMM-ELM', 'Distributed ELM (ADMM)', @ExtremeLearningMachine);

set_training_algorithm('LOC-ELM', @DataDistributedRVFL, 'consensus_max_steps', 0);
set_training_algorithm('CONS-ELM', @DataDistributedRVFL, 'consensus_max_steps', 50);
set_training_algorithm('ADMM-ELM', @DataDistributedRVFL, 'train_algo', 'admm', 'consensus_max_steps', 50);

add_dataset('G', 'G50C', 'g50c');
%add_dataset('G', 'Gtzan', 'gtzan_musicspeech');

add_feature(DistributeData(RandomTopology(2, 0.2)));
add_feature(ExecuteOutputScripts('plot_consensus'));

set_runs(1);