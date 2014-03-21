classdef PerfNrmseTest < matlab.unittest.TestCase
  
    methods (Test)
        
        function testOnePrediction(testCase)
            res = PerfNrmse.compute(4, 2);
            testCase.assertEqual(res, 2);
            res = PerfNrmse.compute(1.5, 1.5);
            testCase.assertEqual(res, 0);
            res = PerfNrmse.compute(1.5, 3);
            testCase.assertEqual(res, 1.5);
        end
        
        function testTwoPredictions(testCase)
            res = PerfNrmse.compute([1, 2.5], [1.5, 4]);
            testCase.assertLessThan(res - 1.0541, eps);
            res = PerfNrmse.compute([1.5, 2], [1.5, 3]);
            testCase.assertEqual(res, 2);
            res = PerfNrmse.compute([1.5, 4], [1.5, 4]);
            testCase.assertEqual(res, 0);
        end
        
    end  
    
end

