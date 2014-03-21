classdef PerfMisclassificationTest < matlab.unittest.TestCase
  
    
    methods (Test)
        
        function testOnePrediction(testCase)
            res = PerfMisclassification.compute(4, 2);
            testCase.assertEqual(res, 1);
            res = PerfMisclassification.compute(2, 2);
            testCase.assertEqual(res, 0);
        end
        
        function testTwoPredictions(testCase)
            res = PerfMisclassification.compute([1, 4], [2 3]);
            testCase.assertEqual(res, 1);
            res = PerfMisclassification.compute([1, 4], [1, 3]);
            testCase.assertEqual(res, 0.5);
            res = PerfMisclassification.compute([1, 4], [1, 4]);
            testCase.assertEqual(res,  0);
        end
        
    end  
    
end

