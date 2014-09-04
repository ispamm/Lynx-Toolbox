% DEMO_DISTRIBUTED - Demo with data-distributed algorithms

%add_model('ELM', 'Centralized ELM', @ExtremeLearningMachine);
%add_model('L-ELM', 'Local ELM', @ExtremeLearningMachine);
add_model('DD-ELM', 'Distributed ELM', @ExtremeLearningMachine);

%set_training_algorithm('L-ELM', @DataDistributedRVFL, 'consensus_steps', 0);
set_training_algorithm('DD-ELM', @DataDistributedRVFL);

add_dataset('G', 'G50C', 'g50c');

add_feature(DistributeData(RandomTopology(2, 0.6)));
add_feature(ExecuteOutputScripts('plot_consensus'));