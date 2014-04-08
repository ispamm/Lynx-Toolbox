classdef SubsetAggregatorTest < matlab.unittest.TestCase
    
    
    methods (Test)
        function testWithTwoSimpleGroups(testCase)
           r = SubsetAggregator(1, 3);
           testCase.assertEqual(r.group(1), 1);
           testCase.assertEqual(r.group(3), 2);
           testCase.assertEqual(r.group([3 1]), [2; 1]);
        end
        
        function testWithTwoComplexGroups(testCase)
           r = SubsetAggregator([1,3], [2,4]);
           testCase.assertEqual(r.group(1), 1);
           testCase.assertEqual(r.group(2), 2);
           testCase.assertEqual(r.group(3), 1);
           testCase.assertEqual(r.group(4), 2);
           testCase.assertEqual(r.group([1 2 3 4]), [1; 2; 1; 2]);
        end
    end
    
end

