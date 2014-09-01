% DEMO_BASIC - Basic demo of the toolbox

%% MODELS

add_model('B', 'Baseline', @BaselineModel);
add_model('ELM', 'Extreme Learning Machine', @ExtremeLearningMachine);

%% DATASETS

add_dataset('GTZAN', 'Gtzan', 'gtzan_musicspeech');
add_dataset('GLASS', 'Glass (UCI)', 'uci_glass');

%% OTHER FEATURES

add_feature(SetSeedPRNG(1));