% CONFIG Configuration file for the simulation. Here it is possible to
% define the algorithms and the datasets for performing the simulation, and
% to set any additional required feature (e.g. parallelization of the
% experiments).

%% ALGORITHMS

add_algorithm('ADA', 'AdaBoost', @Adaboost, 'nLearners', 5);
add_algorithm('B', 'Baseline', @Baseline);
add_algorithm('ELM', 'Extreme Learning Machine', @ExtremeLearningMachine, 'hiddenNodes', 50, 'C', 1, 'type', 'rbf');
add_algorithm('KNN', 'K-Nearest Neighbor', @KNearestNeighbour, 'K', 5, 'distance', 'euclidean');
%add_algorithm('KRLS', 'Kernel RLS', @KernelRecursiveLeastSquare, 'C', 2, 'criterion', 'none');
add_algorithm('LAPRLS', 'Laplacian RLS', @LaplacianRLS, 'C_lap', 0.2, 'C', 0.2, 'n_neighbours', 10);
add_algorithm('LIN', 'Linear', @LinearModel, 'regularization', true, 'alpha', 0.5, 'valParam', 2);
add_algorithm('MLP', 'Multilayer Perceptron', @MultilayerPerceptron, 'hiddenNodes', 25);
add_algorithm('OSELM', 'Online Sequential ELM', @OnlineExtremeLearningMachine, 'hiddenNodes', 40, 'blockSize', 10);
add_algorithm('RN', 'RegularizationNetwork', @RegularizationNetwork, 'C', 10);
%add_algorithm('SAE', 'Stacked Autoencoder', @StackedAutoEncoder, 'hiddenNodes', [20 15]);
%add_algorithm('SVM', 'Support Vector Machine', @SupportVectorMachine, 'nu', 0.3, 'C', 2);

%% WRAPPERS

add_wrapper('LIN', @ChangeConfiguration, 'WDBC', {'regularization'}, {false});
add_wrapper('ADA', @ErrorCorrectingCode);
add_wrapper('OSELM', @Featuresearch_GA, 'gen', 1, 'partition_strategy', HoldoutPartition(0.3));
add_wrapper('RN', @Kernelsearch_GP, 'gen', 1, 'partition_strategy', HoldoutPartition(0.3));
add_wrapper('KNN', @Kpca);
%add_wrapper('KRLS', @OneVersusAll);
add_wrapper('ELM', @ParameterSweep, 2, {'C'}, {'exp'}, [-10 5], [1], 'partition_strategy', HoldoutPartition(0.3));

%% DATASETS

% R
add_dataset('STRENGHT', 'Strenght (UCI)', 'uci_concrete_strength');
add_dataset('GLASS', 'Glass (UCI)', 'uci_glass');
add_dataset('YACHT', 'Yacht (UCI)', 'uci_yacht');

% BC
add_dataset('GTZAN', 'Gtzan', 'gtzan_musicspeech');
add_dataset('IONO', 'Ionosphere (UCI)', 'uci_ionosphere');
add_dataset('WDBC', 'Wdbc (UCI)', 'uci_wdbc');

% MC
add_dataset('ARTIST20', 'Artist 20', 'artist20');
add_dataset('WINERED', 'Wine Red (UCI)', 'uci_wine_red');
add_dataset('YEAST', 'Yeast (UCI)', 'uci_yeast');

% PR
add_dataset('MKG', 'Mackey Glass', 'mackeyglass', 0.15, 'embeddingFactor', 6);

%% PREPROCESSORS

add_preprocessor('STRENGTH', @ApplyKpca, 'outputDimensionality', 15);
add_preprocessor('WINERED', @ApplyPca);

%% ADVANCED FEATURES

% Uncomment to enable the corresponding feature
% set_flag('save_results');     % Save the results
% set_flag('generate_pdf');     % Generate a pdf (requires pdflatex
%                                 available on the path.
% set_flag('parallelized');     % Parallelize the experiments over the
%                                 default cluster.
% set_flag('gpu_enabled');      % Enable GPU support (requires CUDA drivers
%                                 installed.
% set_flag('semisupervised');   % Enable semi-supervised testing.

%% OTHER CONFIGURATIONS

% This changes the performance measure for a given task.
set_performance(Tasks.R, @PerfMse);
set_performance(Tasks.BC, @PerfMCC);

% This sets any additional output scripts.
output_scripts = {'info_gridsearch'};