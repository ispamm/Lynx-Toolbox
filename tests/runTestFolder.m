
% RUNTESTFOLDER Run all tests inside a folder, and display the results.
%
%   [P,F] = RUNTESTFOLDER(FOLDER) run tests inside FOLDER. P and F are the
%   count of tests which are passed and failed respectively
%
%   [P,F] = RUNTESTFOLDER(FOLDER, P, F) is the same, but increments the two
%   counters P and F given as arguments

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function [p, f] = runTestFolder( fold, p, f )

    import matlab.unittest.TestSuite;
    
    if(nargin == 1)
        p = 0;
        f = 0;
    end
    
    % Open the tests in the folder
    fold = fullfile(XmlConfiguration.getRoot(), 'tests',  fold);
    suiteFolder = TestSuite.fromFolder(fold);
    result = run(suiteFolder);
    
    fprintf('\n');
    cprintf('*text', 'Tests for folder %s: \n', fold);
    
    for i=1:length(result)

        if(result(i).Passed)
            fprintf('\n');
            cprintf('comment', '\t Test %s: PASSED', result(i).Name);
        else
            fprintf('\n');
            cprintf('err', '\t Test %s: NOT PASSED', result(i).Name);
        end
    end
    
    fprintf('\n\n\n');
    
    for i=1:length(result)
        p = p + result(i).Passed;
        f = f + result(i).Failed;
    end

end

