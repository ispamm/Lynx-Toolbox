classdef InternalNodeTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function testShiftingOperator(testCase)
           k = GaussKernel(0.5);
           k = ShiftingOperator(k, [], 0.3);
           H = k.evaluate([1 2]);
           testCase.assertEqual(H, 1.3);
           H = k.evaluate([1 2; 1.5 3.5]);
           testCase.assertLessThan(abs(H - [1 exp(-1.25); exp(-1.25) 1] - 0.3), eps );
        end
        
        function testScalingOperator(testCase)
           k = GaussKernel(0.5);
           k = ScalingOperator(k, [], 0.3);
           H = k.evaluate([1 2]);
           testCase.assertEqual(H, 0.3);
           H = k.evaluate([1 2; 1.5 3.5]);
           testCase.assertLessThan(abs(H - 0.3*[1 exp(-1.25); exp(-1.25) 1]), eps );
        end
        
        function testPlusOperator(testCase)
           k1 = GaussKernel(0.5);
           k2 = PolyKernel(1);
           k = PlusOperator(k1, k2);
           H = k.evaluate([1 2]);
           testCase.assertEqual(H, 6);
           H = k.evaluate([1 2; 1.5 3.5]);
           testCase.verifyEqual(H, [1 exp(-1.25); exp(-1.25) 1] + [5 8.5; 8.5 14.5]);
        end
        
        function testMultOperator(testCase)
           k1 = GaussKernel(0.5);
           k2 = PolyKernel(1);
           k = MultOperator(k1, k2);
           H = k.evaluate([1 2]);
           testCase.assertEqual(H, 5);
           H = k.evaluate([1 2; 1.5 3.5]);
           testCase.verifyLessThan(abs(H-[1 exp(-1.25); exp(-1.25) 1].*[5 8.5; 8.5 14.5]), 10^-6);
        end
        
        function testExpOperator(testCase)
           k = GaussKernel(0.5);
           k = ExpOperator(k, []);
           H = k.evaluate([1 2]);
           testCase.assertEqual(H, exp(1));
           H = k.evaluate([1 2; 1.5 3.5]);
           testCase.assertLessThan(abs(H - exp([1 exp(-1.25); exp(-1.25) 1])), eps );
        end
        
        
        
        
    end  
    
end

