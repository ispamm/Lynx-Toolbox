classdef DatasetFactoryPRTest < matlab.unittest.TestCase
    
    properties
       log; 
    end
    
    methods(TestMethodSetup)
        function createDataset(~)
            X = [0; 1; 2; 3; 4];
            Y = [];
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
           testCase.verifyError(@() DatasetFactoryPR.create('PR', 'provaID', 'nome', 'tmp.mat', 1), 'LearnToolbox:Validation:MissingArgument');
           [~, d] = evalc('DatasetFactoryPR.create(''PR'', ''provaID'', ''nome'', ''tmp.mat'', 1, ''embeddingFactor'', 2)');
           testCase.verifyTrue(iscell(d));
           d = d{1};
           testCase.verifyTrue(isa(d, 'Dataset'));
           testCase.verifyEqual(d.id, 'provaID');
           testCase.verifyEqual(d.name, 'nome');
           testCase.verifyEqual(d.task, Tasks.R);
           testCase.verifyEqual(d.X, [0 1; 1 2; 2 3]);
           testCase.verifyEqual(d.Y, [2; 3; 4]);
        end
        
        function testDatasetWithSubsample(testCase)
           [~, d] = evalc('DatasetFactoryPR.create(''PR'', ''provaID'', ''nome'', ''tmp.mat'', 0.8, ''embeddingFactor'', 2)');
           d = d{1};
           testCase.verifyEqual(size(d.X), [2 2]);
           testCase.verifyEqual(size(d.Y, 1), 2);
        end
    end
    
end

