classdef NumericalContainerTest < matlab.unittest.TestCase
    
    methods (Test)

        function testWithSingleInput(testCase)
            p = NumericalContainer();
            p = p.store(1);
            p = p.computeFinalizedValue();
            testCase.verifyEqual(p.getFinalizedValue(), 1);
        end
        
        function testWithTwoInputs(testCase)
            p = NumericalContainer();
            p = p.store(0.1);
            p = p.store(0.3);
            testCase.verifyEqual(p.getFinalizedValue(), 0.2);
        end
        
        function testFormatForOutput(testCase)
            p = NumericalContainer();
            p = p.store(0.1);
            p = p.store(0.3);
            testCase.verifyEqual(p.formatForOutput(), '0.20 (+/- 0.10)');
        end
        
    end  
    
end

