classdef DatasetTest < matlab.unittest.TestCase
    
    methods (Test)
        
        % Test that the dataset is correctly constructed
        function testDatasetConstruction(testCase)
            testCase.verifyInstanceOf(Dataset('a', 'a', Tasks.R, [1 1; 2 2], [0; 0]), 'Dataset');
            testCase.verifyError(@()Dataset(3, 'a', Tasks.R, [1 1; 2 2], [0; 0]), 'LearnToolbox:Validation:WrongInput');
            testCase.verifyError(@()Dataset('a', 5, Tasks.R, [1 1; 2 2], [0; 0]), 'LearnToolbox:Validation:WrongInput');
            testCase.verifyError(@()Dataset('a', 'a', Tasks.R, 'str', [0; 0]), 'LearnToolbox:Validation:WrongInput');
            testCase.verifyError(@()Dataset('a', 'a', Tasks.R, [1 1; 2 2], 'str'), 'LearnToolbox:Validation:WrongInput');
        end
        
        % Test that a single holdout partition is correctly generated
        function testFoldRetrievalHoldout(testCase)
            d = Dataset('a', 'a', Tasks.R, [1 1; 2 2; 4 4], [0; 0; 0]);
            testCase.verifyError(@()d.getFold(1), 'LearnToolbox:Logic:PartitionsNotInitialized');
            d = d.generateNPartitions(1, 0.5);
            [X, Y, X2, Y2] = d.getFold(1);
            testCase.verifySize(X, [2, 2]);
            testCase.verifySize(X2, [1, 2]);
            testCase.verifySize(Y, [2, 1]);
            testCase.verifySize(Y2, [1, 1]);
        end
        
        % Test that a single k-fold partition is correctly generated
        function testFoldRetrievalKFold(testCase)
            d = Dataset('a', 'a', Tasks.R, [1 1; 2 2; 4 4], [0; 0; 0]);
            d = d.generateNPartitions(1, 3);
            [X, Y, X2, Y2] = d.getFold(1);
            testCase.verifySize(X, [2, 2]);
            testCase.verifySize(X2, [1, 2]);
            testCase.verifySize(Y, [2, 1]);
            testCase.verifySize(Y2, [1, 1]);
            [X, Y, X2, Y2] = d.getFold(2);
            testCase.verifySize(X, [2, 2]);
            testCase.verifySize(X2, [1, 2]);
            testCase.verifySize(Y, [2, 1]);
            testCase.verifySize(Y2, [1, 1]);
            testCase.verifyError(@()d.getFold(4), 'LearnToolbox:Validation:WrongInput');
        end
        
        % Test that multiple partitions are correctly generated
        function testFoldGeneration(testCase)
            d = Dataset('a', 'a', Tasks.R, [1 1; 2 2; 4 4], [0; 0; 0]);
            d = d.generateNPartitions(5, 3);
            testCase.verifyError(@()d.setCurrentPartition(6), 'LearnToolbox:Validation:WrongInput');
        end
        
        % Test a single holdout partition in the semi-supervised case
        function testFoldRetrievalSemiSupervised(testCase)
            d = Dataset('a', 'a', Tasks.R, [1 1; 2 2; 4 4; 12 12], [0; 0; 0; 1]);
            d = d.generateNPartitions(1, 0.5, 0.5);
            [X, Y, X2, Y2, Xu] = d.getFold(1);
            testCase.verifySize(X, [1, 2]);
            testCase.verifySize(X2, [1, 2]);
            testCase.verifySize(Y, [1, 1]);
            testCase.verifySize(Y2, [1, 1]);
            testCase.verifySize(Xu, [2, 2]);
        end
        
       
    end  
    
end

