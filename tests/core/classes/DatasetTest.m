classdef DatasetTest < matlab.unittest.TestCase
    
    methods (Test)
        
        % Test that the dataset is correctly constructed
        function testDatasetConstruction(testCase)
            testCase.verifyInstanceOf(Dataset(RealMatrix([1 1; 2 2]), RealLabelsVector([0; 0]), Tasks.R), 'Dataset');
            d = Dataset(RealMatrix([1 1; 2 2]), RealLabelsVector([0; 0]), Tasks.R);
            testCase.verifyError(@()d.setIdAndName(3, 'a'), 'Lynx:Validation:InvalidInput');
            testCase.verifyError(@()d.setIdAndName('a', 5), 'Lynx:Validation:InvalidInput');
            testCase.verifyError(@()Dataset('str', RealLabelsVector([0; 0]), Tasks.R), 'Lynx:Validation:InvalidInput');
            testCase.verifyError(@()Dataset(RealMatrix([1 1; 2 2]), RealLabelsVector('str'), Tasks.R), 'Lynx:Validation:InvalidInput');
        end
        
        % Test that a single holdout partition is correctly generated
        function testFoldRetrievalHoldout(testCase)
            X = RealMatrix([1 1; 2 2; 4 4]);
            Y = RealLabelsVector([1.1; 2.1; 3.1]);
            d = Dataset(X, Y, Tasks.R);
            testCase.verifyError(@()d.getFold(1), 'Lynx:Logical:PartitionsNotInitialized');
            d = d.generateSinglePartition(HoldoutPartition(0.5));
            [d1, d2] = d.getFold(1);
            testCase.verifySize(d1.X.data, [2, 2]);
            testCase.verifySize(d2.X.data, [1, 2]);
            testCase.verifySize(d1.Y.data, [2, 1]);
            testCase.verifySize(d2.Y.data, [1, 1]);
        end
        
        % Test that a single k-fold partition is correctly generated
        function testFoldRetrievalKFold(testCase)
            d = Dataset(RealMatrix([1 1; 2 2; 4 4]), RealLabelsVector([0; 0; 0]), Tasks.R);
            d = d.generateSinglePartition(KFoldPartition(3));
            [d1, d2] = d.getFold(1);
            testCase.verifySize(d1.X.data, [2, 2]);
            testCase.verifySize(d2.X.data, [1, 2]);
            testCase.verifySize(d1.Y.data, [2, 1]);
            testCase.verifySize(d2.Y.data, [1, 1]);
            [d1, d2] = d.getFold(2);
            testCase.verifySize(d1.X.data, [2, 2]);
            testCase.verifySize(d2.X.data, [1, 2]);
            testCase.verifySize(d1.Y.data, [2, 1]);
            testCase.verifySize(d2.Y.data, [1, 1]);
            testCase.verifyError(@()d.getFold(4), 'Lynx:Validation:InvalidInput');
        end
        
        % Test that multiple partitions are correctly generated
        function testFoldGeneration(testCase)
            d = Dataset(RealMatrix([1 1; 2 2; 4 4]), RealLabelsVector([0; 0; 0]), Tasks.R);
            d = d.generateNPartitions(5, KFoldPartition(3));
            testCase.verifyError(@()d.setCurrentPartition(6), 'Lynx:Validation:InvalidInput');
        end
        
        % Test a single holdout partition in the semi-supervised case
        function testFoldRetrievalSemiSupervised(testCase)
            d = Dataset(RealMatrix([1 1; 2 2; 4 4; 12 12]), RealLabelsVector([0; 0; 0; 1]), Tasks.R);
            d = d.generateSinglePartition(HoldoutPartition(0.5), HoldoutPartition(0.5));
            [d1, d2, d3] = d.getFold(1);
            testCase.verifySize(d1.X.data, [1, 2]);
            testCase.verifySize(d2.X.data, [1, 2]);
            testCase.verifySize(d1.Y.data, [1, 1]);
            testCase.verifySize(d2.Y.data, [1, 1]);
            testCase.verifySize(d3.X.data, [2, 2]);
        end
        
       
    end  
    
end

