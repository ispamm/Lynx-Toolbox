classdef KFoldPartitionTest < matlab.unittest.TestCase
    
    methods (Test)
        
        % Test invalid holdout partition creation
        function testInvalidKFoldPartition(testCase)
           testCase.assertError(@() KFoldPartition(0.3), 'LearnToolbox:ValError:InvalidK'); 
           testCase.assertError(@() KFoldPartition(0), 'LearnToolbox:ValError:InvalidK'); 
        end
        
        function testNumFolds(testCase)
            p = KFoldPartition(3);
            p = p.partition(1:8);
            testCase.assertEqual(p.getNumFolds(), 3);
            p = KFoldPartition(6);
            p = p.partition(1:8);
            testCase.assertEqual(p.getNumFolds(), 6);
        end
        
        function testInvalidFoldNumber(testCase)
            p = KFoldPartition(3);
            p = p.partition(1:8);
            testCase.assertError(@() p.setCurrentFold(4), 'LearnToolbox:Validation:WrongInput');
        end
        
        function testKFoldPartitionWithThreeFolds(testCase)
            ind = 1:9;
            
            p = KFoldPartition(3);
            p = p.partition(ind);
            
            % First fold
            trn1 = p.getTrainingIndexes();
            tst1 = p.getTestIndexes();
            
            testCase.assertEqual(sum(trn1 == 1), 6);
            testCase.assertEqual(sum(tst1 == 1), 3);
            testCase.assertTrue(all(trn1 | tst1));
            
            p = p.setCurrentFold(2);
            
            trn2 = p.getTrainingIndexes();
            tst2 = p.getTestIndexes();
            
            testCase.assertEqual(sum(trn2 == 1), 6);
            testCase.assertEqual(sum(tst2 == 1), 3);
            testCase.assertTrue(all(trn2 | tst2));
            
            p = p.setCurrentFold(3);
            
            trn3 = p.getTrainingIndexes();
            tst3 = p.getTestIndexes();
            
            testCase.assertEqual(sum(trn3 == 1), 6);
            testCase.assertEqual(sum(tst3 == 1), 3);
            testCase.assertTrue(all(trn3 | tst3));
            
            testCase.assertTrue(all(tst1 | tst2 | tst3));
        end
        
    end  
    
end

