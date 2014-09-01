classdef NoPartitionTest < matlab.unittest.TestCase
    
    methods (Test)
  
        function testNumFolds(testCase)
            p = NoPartition();
            p = p.partition(1:8);
            testCase.assertEqual(p.getNumFolds(), 1);
        end
        
        function testInvalidFoldNumber(testCase)
            p = NoPartition();
            p = p.partition(1:8);
            testCase.assertError(@() p.setCurrentFold(2), 'Lynx:Validation:InvalidInput');
        end
        
        function testNoPartitionWithThreeCases(testCase)
            
            p = NoPartition();
            p = p.partition(1:3);
            
            trn = p.getTrainingIndexes();
            tst = p.getTestIndexes();
            
            testCase.assertEqual(sum(trn == 1), 3);
            testCase.assertEqual(sum(tst == 1), 3);
            testCase.assertTrue(all(trn & tst));
            
        end
        
    end  
    
end

