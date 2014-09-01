classdef IsInGroupTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function testInInGroupWithEmptyGroupOrString(testCase)
            testCase.verifyFalse(isingroup('a', {}));
            testCase.verifyFalse(isingroup('', {'a'}));
        end
        
        function testIsInGroup(testCase)
            testCase.verifyTrue(isingroup('a', {'a'}));
            testCase.verifyTrue(isingroup('a', {'b', 'a'}));
        end
        
        function testIsNotInGroup(testCase)
            testCase.verifyFalse(isingroup('a', {'b'}));
            testCase.verifyFalse(isingroup('a', {'b', 'c'}));
        end
       
    end  
    
end

