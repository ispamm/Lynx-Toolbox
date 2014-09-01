
% INFO_ALGORITHMS Generate an HTML report on the available models

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

clear all;

models = class_filter(fullfile(XmlConfiguration.getRoot(), 'functionalities/Models'), ...
    'Model');
learningAlgorithms = class_filter(fullfile(XmlConfiguration.getRoot(), 'functionalities/LearningAlgorithms'), ...
    'LearningAlgorithm');

fprintf('Generating report...\n');
report('templates/Available Models.rpt', '-quiet');
%report('templates/Available Models.rpt');