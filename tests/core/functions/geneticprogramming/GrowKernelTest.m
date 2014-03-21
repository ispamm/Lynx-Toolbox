classdef GrowKernelTest < matlab.unittest.TestCase
    
    properties
        firstRandomNumbers;
    end
    
    methods(TestMethodSetup)
        function initRandom(testCase)
           s = rng;
           testCase.firstRandomNumbers = rand(5);
           rng(s); 
        end
    end
    
    methods (Test)
        
        function testBaseKernelWithProbabilityOne(testCase)
            k = growKernel(1, true, [1 0 0 0], []);
            testCase.verifyTrue(isa(k, 'PolyKernel'));
            k = growKernel(1, true, [0 0 0 1], []);
            testCase.verifyTrue(isa(k, 'HyperbolicKernel'));
            testCase.verifyError(@()growKernel(1, true, [1 0 1 0], []), 'K:ProbError');
        end
        
        function testComplexKernelWithProbabilityOne(testCase)
            k = growKernel(2, true, [1 0 0 0], [0 1 0 0 0]);
            testCase.verifyTrue(isa(k, 'ScalingOperator'));
            testCase.verifyTrue(isa(k.leftNode, 'PolyKernel'));
            testCase.assertError(@()growKernel(2, true, [1 0 0 0], [0.5 0.5 0.5 0 1]), 'K:ProbError');
        end
        
        function testBaseKernelWithDifferentProbabilities(testCase)
           k = growKernel(1, true, [0.5 0 0.5 0], []);
           if(testCase.firstRandomNumbers(1) <= 0.5)
               testCase.verifyTrue(isa(k, 'PolyKernel'));
           else
               testCase.verifyTrue(isa(k, 'GaussKernel'));
           end
        end
        
        function testComplexKernelWithDifferentProbabilities(testCase)
           k = growKernel(2, true, [0 0.5 0.5 0], [0.5 0.5 0 0 0]);
           if(testCase.firstRandomNumbers(1) <= 0.5)
               testCase.verifyTrue(isa(k, 'ShiftingOperator'));
           else
               testCase.verifyTrue(isa(k, 'ScalingOperator'));
           end
           if(testCase.firstRandomNumbers(2) <= 0.5)
               testCase.verifyTrue(isa(k.leftNode, 'PolyKernel'));
           else
               testCase.verifyTrue(isa(k.leftNode, 'GaussKernel'));
           end
        end
        
    end
    
end

