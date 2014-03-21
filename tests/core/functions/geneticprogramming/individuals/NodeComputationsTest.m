classdef NodeComputationsTest < matlab.unittest.TestCase
    
    properties
        kernel1;
        kernelShift;
        kernelHyperbolic;
        kernelGauss;
    end
    
    methods(TestMethodSetup)
        function initKernels(testCase)
            testCase.kernelGauss = GaussKernel(0.5);
            testCase.kernelShift = ShiftingOperator(testCase.kernelGauss, [], 0.3);
            testCase.kernelHyperbolic = HyperbolicKernel(0.5, 0.5);
            testCase.kernel1 = PlusOperator(testCase.kernelShift, testCase.kernelHyperbolic);
        end
    end
    
    methods (Test)
        
        function testLength(testCase)
            testCase.verifyEqual(testCase.kernelGauss.length(), 1);
            testCase.verifyEqual(testCase.kernel1.length(), 4);
        end
        
        function testDepth(testCase)
            testCase.verifyEqual(testCase.kernelGauss.depth(), 1);
            testCase.verifyEqual(testCase.kernel1.depth(), 3);
        end
        
        function testGetNthNode(testCase)
            testCase.verifyEqual(testCase.kernelGauss.getNthNode(1), testCase.kernelGauss);
            testCase.verifyEqual(testCase.kernel1.getNthNode(2), testCase.kernelShift);
            testCase.verifyEqual(testCase.kernel1.getNthNode(3), testCase.kernelGauss);
            testCase.verifyEqual(testCase.kernel1.getNthNode(4), testCase.kernelHyperbolic);
            testCase.verifyError(@()testCase.kernel1.getNthNode(0), 'K:OutOfBounds');
            testCase.verifyError(@()testCase.kernel1.getNthNode(5), 'K:OutOfBounds');
        end
        
        function testSetNthNode(testCase)
            k1 = testCase.kernel1;
            testCase.kernel1 = testCase.kernel1.setNthNode(1, testCase.kernelHyperbolic);
            testCase.verifyEqual(testCase.kernel1, testCase.kernelHyperbolic);
            k1 = k1.setNthNode(3, testCase.kernelHyperbolic); 
            testCase.verifyEqual(k1.getNthNode(3), testCase.kernelHyperbolic);
            testCase.verifyError(@()testCase.kernel1.setNthNode(0), 'K:OutOfBounds');
            testCase.verifyError(@()testCase.kernel1.setNthNode(5), 'K:OutOfBounds');
        end
        
        function testPrune(testCase)
            kGauss = testCase.kernelGauss.prune(1);
            testCase.verifyEqual(kGauss, testCase.kernelGauss);
            kbackup = testCase.kernel1;
            testCase.kernel1 = testCase.kernel1.prune(2);
            testCase.verifyEqual(testCase.kernel1.getNthNode(2), testCase.kernelGauss);
            testCase.verifyEqual(testCase.kernel1.getNthNode(3), testCase.kernelHyperbolic);
            kbackup = kbackup.prune(1);
            testCase.verifyEqual(kbackup, testCase.kernelHyperbolic);
        end
        
        function testGetParametersBaseKernel(testCase)
            % Gaussian kernel
            k = GaussKernel(1);
            [a, b] = k.getParameters();
            testCase.verifyEqual(a, 1);
            testCase.verifyFalse(b);
            
            % Polynomial kernel
            k = PolyKernel(0.5);
            [a, b] = k.getParameters();
            testCase.verifyEqual(a, 0.5);
            testCase.verifyTrue(b);
            
            % Hyperbolic kernel
            k = HyperbolicKernel(0.1, 0.2);
            [a, b] = k.getParameters();
            testCase.verifyEqual(a, [0.1; 0.2]);
            testCase.verifyEqual(b, [false; false]);
        end
        
        function testGetParametersComplexKernel(testCase)
            % Scaling operator
            k = ScalingOperator(GaussKernel(1), [], 2);
            [a, b] = k.getParameters();
            testCase.verifyEqual(a, [2; 1]);
            testCase.verifyEqual(b, [0; 0]);
            
            % Shifting operator
            k = ShiftingOperator(PolyKernel(1), [], 3);
            [a, b] = k.getParameters();
            testCase.verifyEqual(a, [3; 1]);
            testCase.verifyEqual(b, [0; 1]);
            
            % Plus operator
            k = PlusOperator(PolyKernel(1), GaussKernel(2));
            [a, b] = k.getParameters();
            testCase.verifyEqual(a, [1; 2]);
            testCase.verifyEqual(b, [1; 0]);
            
            % Mult operator
            k = MultOperator(PolyKernel(1), HyperbolicKernel(0.5, 0.3));
            [a, b] = k.getParameters();
            testCase.verifyEqual(a, [1; 0.5; 0.3]);
            testCase.verifyEqual(b, [1; 0; 0]);
            
            % Exp operator
            k = ExpOperator(GaussKernel(0));
            [a, b] = k.getParameters();
            testCase.verifyEqual(a, [0]);
            testCase.verifyEqual(b, 0);
            
        end
        
        function testSetParametersBaseKernel(testCase)
            k = GaussKernel(1);
            k = k.setParameters(3);
            testCase.verifyEqual(k.params.a, 3);
            k = PolyKernel(0.5);
            k = k.setParameters(0.2);
            testCase.verifyEqual(k.params.p, 0.2);
            k = HyperbolicKernel(0, 0.2);
            k = k.setParameters([0.3; 0.4]);
            testCase.verifyEqual(k.params.a, 0.3);
            testCase.verifyEqual(k.params.b, 0.4);
        end
        
        function testSetParametersComplexKernel(testCase)
            k = ScalingOperator(GaussKernel(1), [], 2);
            k = k.setParameters([0.5; 0.3]);
            testCase.verifyEqual(k.params.scaleFactor, 0.5);
            testCase.verifyEqual(k.leftNode.params.a, 0.3);
            k = ShiftingOperator(HyperbolicKernel(0,1), [], 2);
            k = k.setParameters([0.1; 0.3; 0.5]);
            testCase.verifyEqual(k.params.shiftFactor, 0.1);
            testCase.verifyEqual(k.leftNode.params.a, 0.3);
            testCase.verifyEqual(k.leftNode.params.b, 0.5);
            k = PlusOperator(GaussKernel(1), GaussKernel(2));
            k = k.setParameters([0.1; 0.3;]);
            testCase.verifyEqual(k.leftNode.params.a, 0.1);
            testCase.verifyEqual(k.rightNode.params.a, 0.3);
            k = MultOperator(GaussKernel(1), HyperbolicKernel(0.5,0.3));
            k = k.setParameters([0.1; 0.05; 0.3]);
            testCase.verifyEqual(k.leftNode.params.a, 0.1);
            testCase.verifyEqual(k.rightNode.params.a, 0.05);
            testCase.verifyEqual(k.rightNode.params.b, 0.3);
            k = ExpOperator(PolyKernel(1));
            k = k.setParameters([0]);
            testCase.verifyEqual(k.leftNode.params.p, 0);
        end
        
    end
    
end

