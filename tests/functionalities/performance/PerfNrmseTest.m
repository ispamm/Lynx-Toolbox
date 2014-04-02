classdef PerfNrmseTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function testPerformanceWithSingleInput(testCase)
            testCase.verifyEqual(PerfNrmse.compute(1, 1), 0);
            testCase.verifyEqual(PerfNrmse.compute(1, -2), 3);
        end
        
        function testPerformanceWithTwoInputs(testCase)
            testCase.verifyEqual(PerfNrmse.compute([1 0.5], [1 0.5]), 0);
            testCase.verifyLessThan(abs(PerfNrmse.compute([0.3 0.5], [0.3 1.2]) - 3.5), 3*eps);
            testCase.verifyLessThan(abs(PerfNrmse.compute([0.3 0.5], [0.1 1.2]) - 3.6401), 10^-4);
        end
        
    end  
    
end

