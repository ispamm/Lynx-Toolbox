classdef LeaveOneOutPartitionTest < matlab.unittest.TestCase
    
    methods (Test)
  
        function testNumFolds(testCase)
            p = LeaveOneOutPartition();
            p = p.partition(1:8);
            testCase.assertEqual(p.getNumFolds(), 8);
            p = LeaveOneOutPartition();
            p = p.partition(1:3);
            testCase.assertEqual(p.getNumFolds(), 3);
        end
        
        function testInvalidFoldNumber(testCase)
            p = LeaveOneOutPartition();
            p = p.partition(1:8);
            testCase.assertError(@() p.setCurrentFold(9), 'Lynx:Validation:InvalidInput');
        end
        
        function testLeaveOneOutPartitionWithThreeCases(testCase)
            
            p = LeaveOneOutPartition();
            p = p.partition(1:3);
            
            trn1 = p.getTrainingIndexes();
            tst1 = p.getTestIndexes();
            
            testCase.assertEqual(sum(trn1 == 1), 2);
            testCase.assertEqual(sum(tst1 == 1), 1);
            testCase.assertTrue(all(trn1 | tst1));
            
            p = p.setCurrentFold(2);
            
            trn2 = p.getTrainingIndexes();
            tst2 = p.getTestIndexes();
            
            testCase.assertEqual(sum(trn2 == 1), 2);
            testCase.assertEqual(sum(tst2 == 1), 1);
            testCase.assertTrue(all(trn2 | tst2));
            
            p = p.setCurrentFold(3);
            
            trn3 = p.getTrainingIndexes();
            tst3 = p.getTestIndexes();
            
            testCase.assertEqual(sum(trn3 == 1), 2);
            testCase.assertEqual(sum(tst3 == 1), 1);
            testCase.assertTrue(all(trn3 | tst3));
            
            testCase.assertTrue(all(tst1 | tst2 | tst3));
        end
        
    end  
    
end

