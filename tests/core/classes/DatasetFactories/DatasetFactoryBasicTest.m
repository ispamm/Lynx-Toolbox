classdef DatasetFactoryBasicTest < matlab.unittest.TestCase
    
    properties
       log; 
    end
    
    methods(TestMethodSetup)
        function createDataset(~)
            X = [0 1 2; 3 4 5];
            Y = [1; -1];
            save('tmp.mat', 'X', 'Y');
        end
        
    end
    methods(TestMethodTeardown)
        function deleteDataset(~)
            delete('tmp.mat');
        end
    end
    
    
    methods (Test)
        function testDatasetWithNoSubsample(testCase)
           d = DatasetFactoryBasic.create('BC', 'provaID', 'nome', 'tmp.mat', 1);
           testCase.verifyTrue(iscell(d));
           d = d{1};
           testCase.verifyTrue(isa(d, 'Dataset'));
           testCase.verifyEqual(d.id, 'provaID');
           testCase.verifyEqual(d.name, 'nome');
           testCase.verifyEqual(d.task, Tasks.BC);
           testCase.verifyEqual(d.X, [0 1 2; 3 4 5]);
           testCase.verifyEqual(d.Y, [1; -1]);
        end
        
        function testDatasetWithSubsample(testCase)
           d = DatasetFactoryBasic.create('BC', 'provaID', 'nome', 'tmp.mat', 0.5);
           d = d{1};
           testCase.verifyEqual(size(d.X), [1 3]);
           testCase.verifyEqual(size(d.Y, 1), 1);
        end
    end
    
end

