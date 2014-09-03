
add_model('ELM', 'Centralized ELM', @ExtremeLearningMachine);
add_model('DD-ELM', 'Distributed ELM', @ExtremeLearningMachine);

set_training_algorithm('DD-ELM', @DataDistributedRVFL);

add_dataset('A', 'Adult', 'adult');

add_feature(DistributeData(RandomTopology(2, 1)));