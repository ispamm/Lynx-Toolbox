classdef PerfMaeTest < matlab.unittest.TestCase
  
    
    methods (Test)
        
        function testOnePrediction(testCase)
            res = PerfMae.compute(4, 2);
            testCase.assertEqual(res, 2);
            res = PerfMae.compute(2, 4);
            testCase.assertEqual(res, 2);
            res = PerfMae.compute(1.5, 2.3);
            testCase.verifyLessThan(res - 0.8, eps);
        end
        
        function testTwoPredictions(testCase)
            res = PerfMae.compute([1, 4], [2 3]);
            testCase.assertEqual(res, 1);
            res = PerfMae.compute([1, 1], [3 6]);
            testCase.assertEqual(res, 3.5);
            res = PerfMae.compute([1.5, 1], [3 6]);
            testCase.assertEqual(res,  3.25);
        end
        
    end  
    
end

