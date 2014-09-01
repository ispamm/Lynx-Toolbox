classdef ExactPartitionTest < matlab.unittest.TestCase
    
    methods (Test)
  
        function testNumFolds(testCase)
            p = ExactPartition(5, 3);
            testCase.assertEqual(p.getNumFolds(), 1);
        end
        
        function testInvalidFoldNumber(testCase)
            p = ExactPartition(1, 1);
            p = p.partition(1:8);
            testCase.assertError(@() p.setCurrentFold(2), 'Lynx:Validation:InvalidInput');
        end
        
        function testExactPartitionWithCompleteSplit(testCase)
            
            p = ExactPartition(5, 2);
            p = p.partition(1:7);
            
            trn1 = p.getTrainingIndexes();
            tst1 = p.getTestIndexes();
            
            testCase.assertEqual(sum(trn1 == 1), 5);
            testCase.assertEqual(sum(tst1 == 1), 2);
            
            testCase.assertTrue(all(trn1 | tst1));
            
        end
        
        function testExactPartitionWithIncompleteSplit(testCase)
            
            p = ExactPartition(3, 6);
            p = p.partition(1:12);
            
            trn1 = p.getTrainingIndexes();
            tst1 = p.getTestIndexes();
            
            testCase.assertEqual(sum(trn1 == 1), 3);
            testCase.assertEqual(sum(tst1 == 1), 6);
            
            testCase.assertTrue(sum(trn1 | tst1) == 9);
            
        end
        
    end  
    
end

