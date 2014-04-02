classdef PerfMisclassificationTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function testPerformanceWithSingleInput(testCase)
            testCase.verifyEqual(PerfMisclassification.compute(1, 1), 0);
            testCase.verifyEqual(PerfMisclassification.compute(1, -1), 1);
        end
        
        function testPerformanceWithTwoInputs(testCase)
            testCase.verifyEqual(PerfMisclassification.compute([1 1], [1 1]), 0);
            testCase.verifyEqual(PerfMisclassification.compute([1 -1], [1 1]), 0.5);
            testCase.verifyEqual(PerfMisclassification.compute([-1 -1], [1 1]), 1);
        end
        
        function testPerformanceWithThreeInputs(testCase)
            testCase.verifyEqual(PerfMisclassification.compute([1 -1 1], [-1 1 -1]), 1);
            testCase.verifyLessThan(abs(PerfMisclassification.compute([1 -1 1], [1 1 -1]) - 2/3), eps);
            testCase.verifyLessThan(abs(PerfMisclassification.compute([1 -1 1], [1 -1 -1]) - 1/3), eps);
        end
        
    end  
    
end

