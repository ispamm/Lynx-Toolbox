classdef ConvertScoresTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function testConvertScoresRegression(testCase)
            testCase.verifyEqual(convert_scores([], Tasks.R), []);
            testCase.verifyEqual(convert_scores(0.5, Tasks.R), 0.5);
            testCase.verifyEqual(convert_scores([1; 2.1], Tasks.R), [1; 2.1]);
        end
        
        function testConvertScoresBinaryClassification(testCase)
            testCase.verifyEqual(convert_scores([], Tasks.BC), []);
            testCase.verifyEqual(convert_scores(0.5, Tasks.BC), 1);
            testCase.verifyEqual(convert_scores(-1.2, Tasks.BC), -1);
            testCase.verifyEqual(convert_scores([0.3; 2.1; -0.7], Tasks.BC), [1; 1; -1]);
        end
        
        function testConvertScoresMulticlassClassification(testCase)
            testCase.verifyEqual(convert_scores([], Tasks.MC), []);
            testCase.verifyEqual(convert_scores(0.5, Tasks.MC), 1);
            testCase.verifyEqual(convert_scores([0.5 2.1], Tasks.MC), 2);
            testCase.verifyEqual(convert_scores([0.6 -1.05 0.4], Tasks.MC), 1);
            testCase.verifyEqual(convert_scores([0.5; -0.6], Tasks.MC), [1; 1]);
            testCase.verifyEqual(convert_scores([0.5 2.1; -0.3 -0.6], Tasks.MC), [2; 1]);
            testCase.verifyEqual(convert_scores([0.5 2.1 3; -0.3 -0.6 -1], Tasks.MC), [3; 1]);
        end
       
    end  
    
end

