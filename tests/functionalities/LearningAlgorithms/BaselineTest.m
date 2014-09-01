classdef BaselineTest < matlab.unittest.TestCase
    
    methods (Test)

        function testTrainingAndTestingForRegression(testCase)
            m = BaselineModel('a', 'b');
            a = m.getDefaultTrainingAlgorithm();
            a = a.setCurrentTask(Tasks.R);
            a = a.train([], [1; 3; 2]);
            testCase.verifyEqual(a.model.avValue, 2);
            testCase.verifyEqual(a.test([0.5; 1]), [2; 2]);
        end
        
        function testTrainingAndTestingForClassification(testCase)
            m = BaselineModel('a', 'b');
            a = m.getDefaultTrainingAlgorithm();
            a = a.setCurrentTask(Tasks.BC);
            a = a.train([], [-1; 1; -1; -1]);
            testCase.verifyEqual(a.model.values, [-1; +1]);
            testCase.verifyEqual(a.model.distribution, [0.75 0.25]);
        end

    end  
    
end

