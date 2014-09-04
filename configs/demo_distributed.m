% DEMO_DISTRIBUTED - Demo with data-distributed algorithms

add_model('ELM', 'Centralized ELM', @ExtremeLearningMachine);
add_model('DD-ELM', 'Distributed ELM', @ExtremeLearningMachine);

set_training_algorithm('DD-ELM', @DataDistributedRVFL);

add_dataset('G', 'G50C', 'g50c');

add_feature(DistributeData(RandomTopology(6, 1)));