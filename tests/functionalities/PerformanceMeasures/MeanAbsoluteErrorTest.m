classdef MeanAbsoluteErrorTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function testPerformanceWithSingleInput(testCase)
            p = MeanAbsoluteError();
            err = p.compute(3, 1, []);
            testCase.verifyEqual(err, 2);
        end
        
        function testPerformanceWithTwoInputs(testCase)
            p = MeanAbsoluteError();
            err = p.compute([1 3], [5 6], []);
            testCase.verifyEqual(err, 3.5);
        end

        function testPerformanceComparison(testCase)
            p = MeanAbsoluteError();
            p = p.store(2);
            p2 = MeanAbsoluteError();
            p2 = p2.store(1);
            testCase.verifyFalse(p.isBetterThan(p2));
            testCase.verifyTrue(p2.isBetterThan(p));
        end

    end  
    
end

