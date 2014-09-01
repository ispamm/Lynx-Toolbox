
% RUN_TEST_SUITE Run all the test suite for the Lynx toolbox

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

if verLessThan('matlab', '8.1')
    error('This Matlab version does not support unitary testing. To run the test suite, please upgrade to version 8.1 or higher.');
end

if(~(exist('XmlConfiguration','class') == 8 && XmlConfiguration.checkForConfigurationFile(XmlConfiguration.getRoot())))
    error('You must run the installation script before executing the test suite');
end

clc;
p = 0; f = 0;

tic;

[p, f] = runTestFolder('core/classes/', p, f);
[p, f] = runTestFolder('core/classes/Aggregators', p, f);
[p, f] = runTestFolder('core/classes/ValueContainers', p, f);
[p, f] = runTestFolder('core/classes/Tasks', p, f);

[p, f] = runTestFolder('core/functions/utilities', p, f);
[p, f] = runTestFolder('core/functions/validation', p, f);
[p, f] = runTestFolder('core/functions/other', p, f);
[p, f] = runTestFolder('core/functions/math', p, f);
[p, f] = runTestFolder('core/functions/geneticprogramming', p, f);

[p, f] = runTestFolder('functionalities/PartitionStrategies/', p, f);
[p, f] = runTestFolder('functionalities/PerformanceMeasures', p, f);
[p, f] = runTestFolder('functionalities/LearningAlgorithms', p, f);
[p, f] = runTestFolder('functionalities/Wrappers', p, f);
[p, f] = runTestFolder('functionalities/Preprocessors/', p, f);

cprintf('text', 'Total passed tests: %i.\nTotal failed tests: %i.\n', p, f);
cprintf('text', 'Total testing time: %.2f secs\n', toc);