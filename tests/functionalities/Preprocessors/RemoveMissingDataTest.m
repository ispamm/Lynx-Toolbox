classdef RemoveMissingDataTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function testWithoutMissingData(testCase)
           d = Dataset(RealMatrix([1 2; 3 4; 5 6]), RealLabelsVector([1; 2; 3]), Tasks.R);
           p = RemoveMissingData();
           d = p.process(d);
           testCase.assertEqual(d.X.data, [1 2; 3 4; 5 6]);
           testCase.assertEqual(d.Y.data, [1; 2; 3]);
           testCase.assertEqual(d.task, Tasks.R);
        end
        
        function testWithOneNan(testCase)
           d = Dataset(RealMatrix([1 2; NaN 4; 5 6]), RealLabelsVector([1; 2; 3]), Tasks.R);
           p = RemoveMissingData();
           d = p.process(d);
           testCase.assertEqual(d.X.data, [1 2; 5 6]);
           testCase.assertEqual(d.Y.data, [1; 3]);
           testCase.assertEqual(d.task, Tasks.R);
        end
        
        function testWithTwoNan(testCase)
           d = Dataset(RealMatrix([1 NaN; NaN 4; 5 6]), RealLabelsVector([1; 2; 3]), Tasks.R);
           p = RemoveMissingData();
           d = p.process(d);
           testCase.assertEqual(d.X.data, [5 6]);
           testCase.assertEqual(d.Y.data, [3]);
           testCase.assertEqual(d.task, Tasks.R);
        end
        
        function testWithThreeNan(testCase)
           d = Dataset(RealMatrix([NaN NaN; NaN 4; 5 6]), RealLabelsVector([1; 2; 3]), Tasks.R);
           p = RemoveMissingData();
           d = p.process(d);
           testCase.assertEqual(d.X.data, [5 6]);
           testCase.assertEqual(d.Y.data, [3]);
           testCase.assertEqual(d.task, Tasks.R);
        end
        
        function testEmptyResultingDataset(testCase)
           d = Dataset(RealMatrix([NaN NaN; NaN 4; 5 NaN]), RealLabelsVector([1; 2; 3]), Tasks.R);
           p = RemoveMissingData();
           testCase.assertError(@() p.process(d), 'Lynx:Runtime:EmptyDataset');
        end
        
    end  
    
end

