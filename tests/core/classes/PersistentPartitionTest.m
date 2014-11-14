classdef PersistentPartitionTest < matlab.unittest.TestCase
    
    methods (Test)
  
        function testRepeatedPartition(testCase)
            Y = [1 1 -1 -1 1 -1 1 1]';
            p = PersistentPartition(HoldoutPartition(0.25));
            
            p1 = p.partition(Y);
            p2 = p.partition(Y);
            
            testCase.assertEqual(p1.getTrainingIndexes(), p2.getTrainingIndexes());
            testCase.assertEqual(p1.getTestIndexes(), p2.getTestIndexes());
        end
        
        function testRepeatedPartitionsInDataset(testCase)
            p = PersistentPartition(HoldoutPartition(0.25));
            
            d1 = Dataset(RealMatrix(eye(8)), BinaryLabelsVector([1 1 -1 -1 1 -1 1 1]'), Tasks.BC, '');
            d2 = d1;
            
            d1 = d1.generateSinglePartition(p);
            d2 = d2.generateSinglePartition(p);

            [d_train_1, d_test_1] = d1.getFold(1);
            [d_train_2, d_test_2] = d2.getFold(1);
            
            testCase.assertEqual(d_train_1.X.data, d_train_2.X.data);
            testCase.assertEqual(d_train_1.Y.data, d_train_2.Y.data);
            testCase.assertEqual(d_test_1.X.data, d_test_2.X.data);
            testCase.assertEqual(d_test_1.Y.data, d_test_2.Y.data);
        end
        
        function testDifferentPartitionsInDataset(testCase)
            p = PersistentPartition(HoldoutPartition(0.25));
            
            d1 = Dataset(RealMatrix(eye(8)), BinaryLabelsVector([1 1 -1 -1 1 -1 1 1]'), Tasks.BC, '');
            d2 = Dataset(RealMatrix(eye(8)), BinaryLabelsVector([-1 -1 -1 -1 1 -1 1 1]'), Tasks.BC, '');
            
            d1 = d1.generateSinglePartition(p);
            d2 = d2.generateSinglePartition(p);

            [d_train_1, d_test_1] = d1.getFold(1);
            [d_train_2, d_test_2] = d2.getFold(1);
            
            testCase.assertNotEqual(d_train_1.X.data, d_train_2.X.data);
            testCase.assertNotEqual(d_train_1.Y.data, d_train_2.Y.data);
            testCase.assertNotEqual(d_test_1.X.data, d_test_2.X.data);
            testCase.assertNotEqual(d_test_1.Y.data, d_test_2.Y.data);
        end
        
        function testDifferentPartitionsSameSize(testCase)
            Y1 = [1 1 -1 -1 1 -1 1 1]';
            Y2 = [-1 -1 -1 -1 1 -1 1 1]';
            
            p = PersistentPartition(HoldoutPartition(0.25));
            
            p1 = p.partition(Y1);
            p2 = p.partition(Y2);
            
            testCase.assertNotEqual(p1.getTrainingIndexes(), p2.getTrainingIndexes());
            testCase.assertNotEqual(p1.getTestIndexes(), p2.getTestIndexes());
        end
        
        function testDifferentPartitionsDifferentSize(testCase)
            Y1 = [1 1 -1 -1 1 -1 1 1]';
            Y2 = [-1 -1 -1 -1 1 -1]';
            
            p = PersistentPartition(HoldoutPartition(0.25));
            
            p1 = p.partition(Y1);
            p2 = p.partition(Y2);
            
            testCase.assertNotEqual(p1.getTrainingIndexes(), p2.getTrainingIndexes());
            testCase.assertNotEqual(p1.getTestIndexes(), p2.getTestIndexes());
        end
        
    end  
    
end

