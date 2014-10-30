classdef SubsamplerTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function testWithBasicTask(testCase)
           d = Dataset(RealMatrix([1 2; 3 4; 5 6]), RealLabelsVector([1; 2; 3]),Tasks.R);
           p = Subsampler('d', 0.7);
           d = p.process(d);
           testCase.assertEqual(length(d.Y.data), 2);
           testCase.assertEqual(size(d.X.data), [2 2]);
           testCase.assertEqual(d.task, Tasks.R);
        end
        
        function testWithPredictionTask(testCase)
           d = Dataset(TimeSeries([1; 2; 3; 4; 5; 6]), [],Tasks.R);
           p = Subsampler();
           d = p.process(d);
           testCase.assertEqual(length(d.X.data), 3);
           testCase.assertEqual(d.X.data, [1; 2; 3]);
           testCase.assertEqual(d.task, Tasks.R);
        end
        
    end  
    
end

