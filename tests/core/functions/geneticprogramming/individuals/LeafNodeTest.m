classdef LeafNodeTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function testGaussKernelDimensionalityOne(testCase)
           k = GaussKernel(0.5);
           H = k.evaluate(1);
           testCase.assertEqual(H, 1);
           H = k.evaluate(1, 2);
           testCase.assertEqual(H, exp(-0.5));
           H = k.evaluate([1; 2]);
           testCase.assertEqual(H, [1 exp(-0.5); exp(-0.5) 1]);
        end
        
        function testGaussKernelDimensionalityTwo(testCase)
           k = GaussKernel(0.5);
           H = k.evaluate([1 2]);
           testCase.assertEqual(H, 1);
           H = k.evaluate([1 2; 1.5 3.5]);
           testCase.assertLessThan(H - [1 exp(-1.25); exp(-1.25) 1], eps );
        end
        
        function testLinKernelDimensionalityOne(testCase)
           k = PolyKernel(1);
           H = k.evaluate(1);
           testCase.assertEqual(H, 1);
           H = k.evaluate(1, 0.5);
           testCase.assertEqual(H, 0.5);
           H = k.evaluate([1; 2]);
           testCase.assertEqual(H, [1 2; 2 4]);
        end
        
        function testLinKernelDimensionalityTwo(testCase)
           k = PolyKernel(1);
           H = k.evaluate([1 2]);
           testCase.assertEqual(H, 5);
           H = k.evaluate([1 2; 1.5 3.5]);
           testCase.assertEqual(H, [5 8.5; 8.5 14.5]);
        end
        
        function testPolyKernelDimensionalityOne(testCase)
           k = PolyKernel(3);
           H = k.evaluate(1);
           testCase.assertEqual(H, 1);
           H = k.evaluate(1, 0.5);
           testCase.assertEqual(H, 0.5^3);
           H = k.evaluate([1; 2]);
           testCase.assertEqual(H, [1 8; 8 64]);
        end
        
        function testPolyKernelDimensionalityTwo(testCase)
           k = PolyKernel(3);
           H = k.evaluate([1 2]);
           testCase.assertEqual(H, 125);
           H = k.evaluate([1 2; 1.5 3.5]);
           testCase.assertEqual(H, [125 8.5^3; 8.5^3 14.5^3]);
        end
        
        function testHyperbolicKernelDimensionalityOne(testCase)
           k = HyperbolicKernel(0.5, 1);
           H = k.evaluate(1);
           testCase.assertEqual(H, tanh(1.5));
           H = k.evaluate(1, 0.5);
           testCase.assertEqual(H, tanh(0.5^2 + 1));
           H = k.evaluate([1; 2]);
           testCase.assertLessThan(abs(H - [tanh(1.5) tanh(2);tanh(2) tanh(3)]), eps);
        end
        
        function testHyperbolicKernelDimensionalityTwo(testCase)
           k = HyperbolicKernel(0.5, 1);
           H = k.evaluate([1 2]);
           testCase.assertEqual(H, tanh(3.5));
           H = k.evaluate([1 2; 1.5 3.5]);
           testCase.assertEqual(H, [tanh(3.5) tanh(0.5*8.5 + 1); tanh(0.5*8.5 + 1) tanh(0.5*14.5+1)]);
           H = k.evaluate([1 2], [0.5 0.5]);
           testCase.assertEqual(H, tanh(1.75));
        end
        
    end  
    
end

