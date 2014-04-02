classdef PerfOppositeMCCTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function testPerformanceWithSingleInput(testCase)
            testCase.verifyEqual(PerfOppositeMCC.compute(1, 1), -1);
            testCase.verifyEqual(PerfOppositeMCC.compute(1, -1), 0);
        end
        
        function testPerformanceWithTwoInputs(testCase)
            testCase.verifyEqual(PerfOppositeMCC.compute([1 1], [1 1]), -1);
            testCase.verifyEqual(PerfOppositeMCC.compute([1 -1], [1 1]), 0);
            testCase.verifyEqual(PerfOppositeMCC.compute([-1 -1], [1 1]), 0);
        end
        
        function testPerformanceWithThreeInputs(testCase)
            testCase.verifyEqual(PerfOppositeMCC.compute([1 -1 1], [-1 1 -1]), 1);
            testCase.verifyEqual(PerfOppositeMCC.compute([1 -1 1], [1 1 -1]), 0.5);
            testCase.verifyEqual(PerfOppositeMCC.compute([1 -1 1], [-1 -1 -1]), 0);
        end
        
    end  
    
end

