classdef IsInRangeTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function testIsInRangeBetween0And1(testCase)
            testCase.verifyTrue(isinrange(0.3));
            testCase.verifyTrue(isinrange(0))
            testCase.verifyTrue(isinrange(1));
            testCase.verifyTrue(isinrange(0.3, false));
            testCase.verifyFalse(isinrange(0, false));
            testCase.verifyFalse(isinrange(1, false));
            testCase.verifyFalse(isinrange(3));
            testCase.verifyFalse(isinrange(1.5, false));
            testCase.verifyFalse(isinrange(-1.2));
            testCase.verifyFalse(isinrange(-0.7, false));
        end
        
        function testIsInRangeWithCustomRange(testCase)
            testCase.verifyTrue(isinrange(0.4, 0.1, 0.5));
            testCase.verifyFalse(isinrange(0.4, 0.1, 0.3));
            testCase.verifyTrue(isinrange(0.4, 0.1, 0.5, false));
            testCase.verifyFalse(isinrange(0.4, 0.1, 0.4, false));
        end
       
    end  
    
end

