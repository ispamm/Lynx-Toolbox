classdef DatasetFactoryMLTest < matlab.unittest.TestCase
    
    properties
       log; 
    end
    
    methods(TestMethodSetup)
        function createDataset(~)
            X = [1 2; 3 4; 5 6];
            Y = [1 -1; -1 1; 1 -1];
            labels_info = {'a', 'b'};
            save('tmp.mat', 'X', 'Y', 'labels_info');
        end
        
    end
    methods(TestMethodTeardown)
        function deleteDataset(~)
            delete('tmp.mat');
        end
    end
    
    
    methods (Test)
        function testDatasetWithNoSubsample(testCase)
           [~, dfull] = evalc('DatasetFactoryML.create(''ML'', ''provaID'', ''nome'', ''tmp.mat'', 1)');
           testCase.verifyTrue(iscell(dfull));
           testCase.verifyEqual(length(dfull), 2);
           d = dfull{1};
           testCase.verifyTrue(isa(d, 'Dataset'));
           testCase.verifyEqual(d.id, 'provaID-1');
           testCase.verifyEqual(d.name, 'nome (a)');
           testCase.verifyEqual(d.task, Tasks.BC);
           testCase.verifyEqual(d.X, [1 2; 3 4; 5 6]);
           testCase.verifyEqual(d.Y, [1; -1; 1]);
           d = dfull{2};
           testCase.verifyTrue(isa(d, 'Dataset'));
           testCase.verifyEqual(d.id, 'provaID-2');
           testCase.verifyEqual(d.name, 'nome (b)');
           testCase.verifyEqual(d.task, Tasks.BC);
           testCase.verifyEqual(d.X, [1 2; 3 4; 5 6]);
           testCase.verifyEqual(d.Y, [-1; 1; -1]);
        end
        
        function testDatasetWithSubsample(testCase)
           [~, dfull] = evalc('DatasetFactoryML.create(''ML'', ''provaID'', ''nome'', ''tmp.mat'', 0.7)');
           d = dfull{1};
           testCase.verifyEqual(size(d.X), [2 2]);
           testCase.verifyEqual(size(d.Y, 1), 2);
           d = dfull{2};
           testCase.verifyEqual(size(d.X), [2 2]);
           testCase.verifyEqual(size(d.Y, 1), 2);
        end
    end
    
end

