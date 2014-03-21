classdef CrossoverTest < matlab.unittest.TestCase
    
    properties
        nthNode1;
        nthNode2;
    end
    
    methods(TestMethodSetup)
        function initRandom(testCase)
            s = rng;
            testCase.nthNode1 = randi(2);
            testCase.nthNode2 = randi(4);
            rng(s);
        end
    end
    
    methods (Test)
        
        function testCrossoverBaseKernels(testCase)
            [k1, k2] = crossover(GaussKernel(1), PolyKernel(3), 3);
            testCase.verifyTrue(isa(k1, 'PolyKernel'));
            testCase.verifyTrue(isa(k2, 'GaussKernel'));
        end
        
        function testCrossoverComplexKernels(testCase)
            k1parent = ShiftingOperator(HyperbolicKernel(1,1), [], 1);
            k2parent = PlusOperator(GaussKernel(2), ScalingOperator(PolyKernel(2), [], 1));
            [k1, k2] = crossover(k1parent, k2parent, 5);
            testCase.verifyTrue(isa(k1.getNthNode(testCase.nthNode1), class(k2parent.getNthNode(testCase.nthNode2))));
            testCase.verifyTrue(isa(k2.getNthNode(testCase.nthNode2), class(k1parent.getNthNode(testCase.nthNode1))));
        end
        
    end
    
end

