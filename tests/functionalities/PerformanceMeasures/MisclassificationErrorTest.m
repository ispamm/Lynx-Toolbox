classdef MisclassificationErrorTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function testPerformanceWithSingleInput(testCase)
            p = MisclassificationError();
            err = p.compute(1, 1, []);
            testCase.verifyEqual(err, 0);
            
            err = p.compute(1, -1, []);
            testCase.verifyEqual(err, 1);
        end
        
        function testPerformanceWithTwoInputs(testCase)
            p = MisclassificationError();
            err = p.compute([1 1], [1 1], []);
            testCase.verifyEqual(err, 0);
            
            err = p.compute([1 -1], [1 1], []);
            testCase.verifyEqual(err, 0.5);
            
            err = p.compute([-1 -1], [1 1], []);
            testCase.verifyEqual(err, 1);
        end
        
        function testPerformanceWithThreeInputs(testCase)
            p = MisclassificationError();
            err = p.compute([1 -1 1], [1 1 -1], []);
            testCase.verifyLessThan(abs(err - 2/3), eps);
        end

    end  
    
end

