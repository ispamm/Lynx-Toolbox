classdef PerfMseTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function testPerformanceWithSingleInput(testCase)
            testCase.verifyEqual(PerfMse.compute(1, 1), 0);
            testCase.verifyEqual(PerfMse.compute(1, -2), 9);
        end
        
        function testPerformanceWithTwoInputs(testCase)
            testCase.verifyEqual(PerfMse.compute([1 0.5], [1 0.5]), 0);
            testCase.verifyLessThan(abs(PerfMse.compute([0.3 0.5], [0.3 1.2]) - 0.245), eps);
            testCase.verifyLessThan(abs(PerfMse.compute([0.3 0.5], [0.1 1.2]) - 0.265), eps);
        end
        
    end  
    
end

