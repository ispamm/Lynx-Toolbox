classdef RangeAggregatorTest < matlab.unittest.TestCase
    
    
    methods (Test)
        function testWithTwoGroups(testCase)
           r = RangeAggregator(0.5);
           testCase.assertEqual(r.group(0), 1);
           testCase.assertEqual(r.group(0.6), 2);
           testCase.assertEqual(r.group([-1 1.2]), [1; 2]);
        end
        
        function testWithThreeGroups(testCase)
           r = RangeAggregator([0.3 0.6]);
           testCase.assertEqual(r.group(0), 1);
           testCase.assertEqual(r.group(0.5), 2);
           testCase.assertEqual(r.group(1), 3);
           testCase.assertEqual(r.group([-1 1.2 0.5]), [1; 3; 2]);
        end
    end
    
end

