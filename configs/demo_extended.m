% DEMO_EXTENDED - Extended demo of the toolbox

%% MODELS

add_model('B', 'Baseline', @BaselineModel);

add_model('ELM', 'ELM', @ExtremeLearningMachine);
add_model('SVM', 'SVM', @SupportVectorMachine);

% Uncomment for LibSVM
% set_training_algorithm('SVM', @LibSVM); 

add_wrapper('ELM', @ParameterSweep, {'C'}, {10.^(-5:5)});
add_wrapper('SVM', @OneVersusAll);

%% DATASETS

add_dataset('GTZAN', 'Gtzan', 'gtzan_musicspeech');
add_dataset('GLASS', 'Glass (UCI)', 'uci_glass');
add_dataset('YACHT', 'Yacht (UCI)', 'uci_yacht');

%% ADDITIONAL PERFORMANCE MEASURES

add_performance(Tasks.R, MeanAbsoluteError());
add_performance(Tasks.BC, RocCurve());

%% OTHER FEATURES

% Uncomment for statistical test (requires LibSVM training algorithm)
% add_feature(CheckSignificance(FriedmanTest()));

add_feature(SetSeedPRNG(1));
add_feature(ExecuteOutputScripts('info_gridsearch'));
add_feature(SaveResults('demo_results'));
