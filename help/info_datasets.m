
% INFO_DATASETS Generate an HTML report on the available datasets.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

tasks = class_filter(fullfile(XmlConfiguration.getRoot(), 'core/classes/Tasks/'), 'BasicTask');

fprintf('Generating report...\n');
report('templates/Available Datasets.rpt', '-quiet');
%report('templates/Available Datasets.rpt');