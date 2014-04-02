classdef HoldoutPartitionTest < matlab.unittest.TestCase
    
    methods (Test)
        
        % Test invalid holdout partition creation
        function testInvalidHoldoutPartition(testCase)
           testCase.assertError(@() HoldoutPartition(-0.1), 'LearnToolbox:ValError:HoldoutFractionInvalid'); 
           testCase.assertError(@() HoldoutPartition(1.5), 'LearnToolbox:ValError:HoldoutFractionInvalid'); 
        end
        
        function testNumFolds(testCase)
            p = HoldoutPartition(0.5);
            p = p.partition(1:8);
            testCase.assertEqual(p.getNumFolds(), 1);
        end
        
        function testInvalidFoldNumber(testCase)
            p = HoldoutPartition(0.5);
            p = p.partition(1:8);
            testCase.assertError(@() p.setCurrentFold(2), 'LearnToolbox:Validation:WrongInput');
        end
        
        function testHoldoutPartitioningFiftyPercent(testCase)
            ind = 1:6;
            p = HoldoutPartition(0.5);
            p = p.partition(ind);
            trn = p.getTrainingIndexes();
            tst = p.getTestIndexes();
            testCase.assertEqual(sum(trn == 1), 3);
            testCase.assertEqual(sum(tst == 1), 3);
            testCase.assertTrue(all(trn | tst));
        end
        
        function testHoldoutPartitioningEightyPercent(testCase)
            ind = 1:10;
            p = HoldoutPartition(0.8);
            p = p.partition(ind);
            trn = p.getTrainingIndexes();
            tst = p.getTestIndexes();
            testCase.assertEqual(sum(trn == 1), 2);
            testCase.assertEqual(sum(tst == 1), 8);
            testCase.assertTrue(all(trn | tst));
        end
        
    end  
    
end

