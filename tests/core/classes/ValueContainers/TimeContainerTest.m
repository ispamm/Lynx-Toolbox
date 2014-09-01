classdef TimeContainerTest < matlab.unittest.TestCase
    
    methods (Test)

        function testWithThreeSuccessiveInputs(testCase)
            p = TimeContainer();
            p = p.store(2);
            p = p.store(7);
            testCase.verifyEqual(p.getFinalizedValue(), 4.5);
            p = p.store(3);
            testCase.verifyEqual(p.getFinalizedValue(), 4);
        end
        
        
        function testFormatForOutput(testCase)
            p = TimeContainer();
            p = p.store(1);
            p = p.store(5);
            testCase.verifyEqual(p.formatForOutput(), '3.00 secs (+/- 2.00 secs)');
        end
        
    end  
    
end

