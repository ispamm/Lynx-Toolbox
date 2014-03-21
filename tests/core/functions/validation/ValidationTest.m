classdef ValidationTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function testIsNatural(testCase)
            testCase.verifyTrue(isnatural(3));
            testCase.verifyFalse(isnatural(-3));
            testCase.verifyFalse(isnatural(2.3));
            testCase.verifyFalse(isnatural('a'));
            testCase.verifyTrue(isnatural(6, true));
            testCase.verifyFalse(isnatural(0, true));
        end
       
    end  
    
end

