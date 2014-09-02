classdef SubsamplerTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function testWithBasicTask(testCase)
           d = Dataset.generateAnonymousDataset(Tasks.R, [1 2; 3 4; 5 6], [1; 2; 3]);
           p = Subsampler('d', 0.7);
           d = p.process(d);
           testCase.assertEqual(length(d.Y), 2);
           testCase.assertEqual(size(d.X), [2 2]);
           testCase.assertEqual(d.task, Tasks.R);
        end
        
        function testWithPredictionTask(testCase)
           d = Dataset.generateAnonymousDataset(Tasks.PR, [1; 2; 3; 4; 5; 6], []);
           p = Subsampler();
           d = p.process(d);
           testCase.assertEqual(length(d.X), 3);
           testCase.assertEqual(d.X, [1; 2; 3]);
           testCase.assertEqual(d.task, Tasks.PR);
        end
        
    end  
    
end

