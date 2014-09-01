classdef MatthewCorrelationCoefficientTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function testPerformanceWithSingleInput(testCase)
            p = MatthewCorrelationCoefficient();
            err = p.compute(1, 1, []);
            testCase.verifyEqual(err, 1);
            
            err = p.compute(1, -1, []);
            testCase.verifyEqual(err, 0);
        end
        
        function testPerformanceWithTwoInputs(testCase)
            p = MatthewCorrelationCoefficient();
            err = p.compute([1 1], [1 1], []);
            testCase.verifyEqual(err, 1);
        end
        
        function testPerformanceWithThreeInputs(testCase)
            p = MatthewCorrelationCoefficient();
            err = p.compute([1 -1 1], [1 1 -1], []);
            testCase.verifyEqual(err, -0.5);
        end
        
        function testPerformanceComparison(testCase)
            p = MatthewCorrelationCoefficient();
            p = p.store(0);
            p2 = MatthewCorrelationCoefficient();
            p2 = p2.store(-0.1);
            testCase.verifyTrue(p.isBetterThan(p2));
            p2 = MatthewCorrelationCoefficient();
            p2 = p2.store(0.9);
            testCase.verifyFalse(p.isBetterThan(p2));
        end

    end  
    
end

