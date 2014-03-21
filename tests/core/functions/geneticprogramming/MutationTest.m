classdef MutationTest < matlab.unittest.TestCase
    
    properties
        terminalNode;
        nthNode;
    end
    
    methods(TestMethodSetup)
        function initRandom(testCase)
            s = rng;
            testCase.nthNode = randi(2);
            testCase.terminalNode = rand();
            rng(s);
        end
    end
    
    methods (Test)
        
        function testMutationBaseKernel(testCase)
            k = mutation(GaussKernel(1), [1 0 0 0], [0 0 0 0]);
            testCase.verifyTrue(isa(k, 'PolyKernel'));
        end
        
        function testMutationComplexKernel(testCase)
            k = mutation(ScalingOperator(GaussKernel(1), [], 2), [1 0 0 0], [0 0 0 0 1]);
            if(testCase.nthNode == 2)
                testCase.verifyTrue(isa(k.getNthNode(2), 'PolyKernel'));
            else
                if(testCase.terminalNode  < 0.3)
                    testCase.verifyTrue(isa(k, 'PolyKernel'));
                else
                    testCase.verifyTrue(isa(k, 'ExpOperator'));
                end
            end
        end
        
    end
    
end

