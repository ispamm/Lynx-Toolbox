% DEFAULT_CONFIG Default configuration file.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

%% SIMULATION PARAMETERS

% The simulation name is used for creating the folder where the results are
% saved. If the folder already exists, a warning will be issued and results
% will be overwritten. The default is 'test', uncomment to change.
simulationName = 'test';

% This is the seed for initializing the PRNG of Matlab. The default is
% 'shuffle' (random seed), uncomment to change.
seed_prng = 'shuffle';

% Number of times each experiment is performed. Default is 1.
nRuns = 1;

% Parameter for selecting the subdivision of data. Set to [0,1] for
% holdout, or to a natural number for k-fold cross-validation. Default is a
% 3-fold cross validation.
testParameter = 3;

% If semi-supervised testing is enabled, training data is divided using
% this percentage into a labeled dataset and an additional unlabeled
% dataset. Default is 0.25.
semisupervised_holdout = 0.25;

output_scripts = [];