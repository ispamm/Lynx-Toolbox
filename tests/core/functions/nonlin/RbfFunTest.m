classdef RbfFunTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function testSingleNodeSingleInputDimensionalityOne(testCase)
            H = rbffun(1, 3, 0.5);
            testCase.verifyEqual(H, exp(-2));
        end
        
        function testSingleNodeSingleInputDimensionalityTwo(testCase)
            H = rbffun([1 2], [3 1], 0.5);
            testCase.verifyEqual(H, exp(-2.5));
        end
        
        function testSingleNodeTwoInputsDimensionalityTwo(testCase)
            H = rbffun([1 2; 1.5 0.5], [3 1], 0.5);
            testCase.verifyEqual(H, [exp(-2.5); exp(-1.25)]);
        end
        
        function testTwoNodesTwoInputsDimensionalityTwo(testCase)
            H = rbffun([1 2; 1.5 0.5], [3 1; 2 2], [0.5 2]);
            testCase.verifyEqual(H, [exp(-2.5) exp(-2); exp(-1.25) exp(-5);]);
        end
 
        
    end  
    
end

