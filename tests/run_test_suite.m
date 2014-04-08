
% RUN_TEST_SUITE Run all the test suite.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

if verLessThan('matlab', '8.1')
    error('This Matlab version does not support unitary testing. To run the test suite, please upgrade to version 8.1 or higher.');
end

clc;
p = 0; f = 0;

[p, f] = runTestFolder('core/classes/', p, f);
[p, f] = runTestFolder('core/classes/DatasetFactories/', p, f);
[p, f] = runTestFolder('core/classes/PartitionStrategies/', p, f);
[p, f] = runTestFolder('core/classes/Aggregators/', p, f);
[p, f] = runTestFolder('core/functions/geneticprogramming', p, f);
[p, f] = runTestFolder('core/functions/utilities', p, f);
[p, f] = runTestFolder('core/functions/performance', p, f);
[p, f] = runTestFolder('core/functions/nonlin', p, f);
[p, f] = runTestFolder('core/functions/validation', p, f);
[p, f] = runTestFolder('functionalities/performance/', p, f);

cprintf('text', 'Total passed tests: %i.\nTotal failed tests: %i.\n', p, f);