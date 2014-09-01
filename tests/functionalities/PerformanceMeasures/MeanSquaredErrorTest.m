classdef MeanSquaredErrorTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function testPerformanceWithSingleInput(testCase)
            p = MeanSquaredError();
            err = p.compute(1, 1, []);
            testCase.verifyEqual(err, 0);
            
            err = p.compute(1, -2, []);
            testCase.verifyEqual(err, 9);
        end
        
        function testPerformanceWithTwoInputs(testCase)
            p = MeanSquaredError();
            err = p.compute([1 0.5], [1 0.5], []);
            testCase.verifyEqual(err, 0);
            
            err = p.compute([0.3 0.5], [0.3 1.2], []);
            testCase.verifyTrue(abs(err) - 0.245 < eps);
        end
        
        function testPerformanceComparison(testCase)
            p = MeanSquaredError();
            p = p.store(2.3);
            p2 = MeanSquaredError();
            p2 = p2.store(0.7);
            testCase.verifyFalse(p.isBetterThan(p2));
            testCase.verifyTrue(p2.isBetterThan(p));
        end

    end  
    
end

