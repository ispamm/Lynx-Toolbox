classdef KernelMatrixTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function testRbfKernelDimensionalityOne(testCase)
           H = kernel_matrix(1, 'rbf', 0.5);
           testCase.assertEqual(H, 1);
           H = kernel_matrix(1, 'rbf', 0.5, 2);
           testCase.assertEqual(H, exp(-0.5));
           H = kernel_matrix([1; 2], 'rbf', 0.5);
           testCase.assertEqual(H, [1 exp(-0.5); exp(-0.5) 1]);
        end
        
        function testRbfKernelDimensionalityTwo(testCase)
           H = kernel_matrix([1 2], 'rbf', 0.5);
           testCase.assertEqual(H, 1);
           H = kernel_matrix([1 2; 1.5 3.5], 'rbf', 0.5);
           testCase.assertEqual(H, [1 exp(-1.25); exp(-1.25) 1]);
        end
        
        function testLinKernelDimensionalityOne(testCase)
           H = kernel_matrix(1, 'lin');
           testCase.assertEqual(H, 1);
           H = kernel_matrix(1, 'lin', [], 0.5);
           testCase.assertEqual(H, 0.5);
           H = kernel_matrix([1; 2], 'lin');
           testCase.assertEqual(H, [1 2; 2 4]);
        end
        
        function testLinKernelDimensionalityTwo(testCase)
           H = kernel_matrix([1 2], 'lin');
           testCase.assertEqual(H, 5);
           H = kernel_matrix([1 2; 1.5 3.5], 'lin');
           testCase.assertEqual(H, [5 8.5; 8.5 14.5]);
        end
        
        function testPolyKernelDimensionalityOne(testCase)
           H = kernel_matrix(1, 'poly', 3);
           testCase.assertEqual(H, 1);
           H = kernel_matrix(1, 'poly', 3, 0.5);
           testCase.assertEqual(H, 0.5^3);
           H = kernel_matrix([1; 2], 'poly', 3);
           testCase.assertEqual(H, [1 8; 8 64]);
        end
        
        function testPolyKernelDimensionalityTwo(testCase)
           H = kernel_matrix([1 2], 'poly', 3);
           testCase.assertEqual(H, 125);
           H = kernel_matrix([1 2; 1.5 3.5], 'poly', 2);
           testCase.assertEqual(H, [25 8.5^2; 8.5^2 14.5^2]);
        end
        
    end  
    
end

