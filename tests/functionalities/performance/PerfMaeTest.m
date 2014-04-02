classdef PerfMaeTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function testPerformanceWithSingleInput(testCase)
            err = PerfMae.compute(3, 1);
            testCase.verifyEqual(err, 2);
        end
        
        function testPerformanceWithTwoInputs(testCase)
            err = PerfMae.compute([1 3], [5 6]);
            testCase.verifyEqual(err, 3.5);
        end
        
    end  
    
end

