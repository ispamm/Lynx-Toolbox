classdef DatasetTest < matlab.unittest.TestCase
    
    methods (Test)
        
        % Test that the dataset is correctly constructed
        function testDatasetConstruction(testCase)
            testCase.verifyInstanceOf(Dataset('a', 'a', Tasks.R, [1 1; 2 2], [0; 0]), 'Dataset');
            testCase.verifyError(@()Dataset(3, 'a', Tasks.R, [1 1; 2 2], [0; 0]), 'Lynx:Validation:InvalidInput');
            testCase.verifyError(@()Dataset('a', 5, Tasks.R, [1 1; 2 2], [0; 0]), 'Lynx:Validation:InvalidInput');
            testCase.verifyError(@()Dataset('a', 'a', Tasks.R, 'str', [0; 0]), 'Lynx:Validation:InvalidInput');
            testCase.verifyError(@()Dataset('a', 'a', Tasks.R, [1 1; 2 2], 'str'), 'Lynx:Validation:InvalidInput');
        end
        
        % Test that a single holdout partition is correctly generated
        function testFoldRetrievalHoldout(testCase)
            X = [1 1; 2 2; 4 4];
            Y = [1.1; 2.1; 3.1];
            d = Dataset('a', 'a', Tasks.R, X, Y);
            testCase.verifyError(@()d.getFold(1), 'Lynx:Logical:PartitionsNotInitialized');
            d = d.generateSinglePartition(HoldoutPartition(0.5));
            [X1, Y1, X2, Y2] = d.getFold(1);
            testCase.verifySize(X1, [2, 2]);
            testCase.verifySize(X2, [1, 2]);
            testCase.verifySize(Y1, [2, 1]);
            testCase.verifySize(Y2, [1, 1]);
        end
        
        % Test that a single k-fold partition is correctly generated
        function testFoldRetrievalKFold(testCase)
            d = Dataset('a', 'a', Tasks.R, [1 1; 2 2; 4 4], [0; 0; 0]);
            d = d.generateSinglePartition(KFoldPartition(3));
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
            testCase.verifyError(@()d.getFold(4), 'Lynx:Validation:InvalidInput');
        end
        
        % Test that multiple partitions are correctly generated
        function testFoldGeneration(testCase)
            d = Dataset('a', 'a', Tasks.R, [1 1; 2 2; 4 4], [0; 0; 0]);
            d = d.generateNPartitions(5, KFoldPartition(3));
            testCase.verifyError(@()d.setCurrentPartition(6), 'Lynx:Validation:InvalidInput');
        end
        
        % Test a single holdout partition in the semi-supervised case
        function testFoldRetrievalSemiSupervised(testCase)
            d = Dataset('a', 'a', Tasks.R, [1 1; 2 2; 4 4; 12 12], [0; 0; 0; 1]);
            d = d.generateSinglePartition(HoldoutPartition(0.5), HoldoutPartition(0.5));
            [X, Y, X2, Y2, Xu] = d.getFold(1);
            testCase.verifySize(X, [1, 2]);
            testCase.verifySize(X2, [1, 2]);
            testCase.verifySize(Y, [1, 1]);
            testCase.verifySize(Y2, [1, 1]);
            testCase.verifySize(Xu, [2, 2]);
        end
        
       
    end  
    
end

