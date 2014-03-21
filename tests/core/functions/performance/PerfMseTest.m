classdef PerfMseTest < matlab.unittest.TestCase
  
    
    methods (Test)
        
        function testOnePrediction(testCase)
            res = PerfMse.compute(4, 2);
            testCase.assertEqual(res, 4);
            res = PerfMse.compute(1.5, 1.5);
            testCase.assertEqual(res, 0);
            res = PerfMse.compute(1.5, 3);
            testCase.assertEqual(res, 2.25);
        end
        
        function testTwoPredictions(testCase)
            res = PerfMse.compute([1, 2], [1.5, 4]);
            testCase.assertEqual(res, 2.125);
            res = PerfMse.compute([1.5, 2], [1.5, 3]);
            testCase.assertEqual(res, 0.5);
            res = PerfMse.compute([1.5, 4], [1.5, 4]);
            testCase.assertEqual(res, 0);
        end
        
    end  
    
end

