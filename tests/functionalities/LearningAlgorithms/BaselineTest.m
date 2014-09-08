classdef BaselineTest < matlab.unittest.TestCase
    
    methods (Test)

        function testTrainingAndTestingForRegression(testCase)
            m = BaselineModel('a', 'b');
            a = m.getDefaultTrainingAlgorithm();
            a = a.train(Dataset(RealMatrix([]), IntegerLabelsVector([1; 3; 2]), Tasks.R));
            testCase.verifyEqual(a.model.avValue, 2);
            testCase.verifyEqual(a.test(Dataset(RealMatrix([0.5; 1]), [], Tasks.R)), [2; 2]);
        end
        
        function testTrainingAndTestingForClassification(testCase)
            m = BaselineModel('a', 'b');
            a = m.getDefaultTrainingAlgorithm();
            a = a.train(Dataset(RealMatrix([]), BinaryLabelsVector([-1; 1; -1; -1]), Tasks.BC));
            testCase.verifyEqual(a.model.values, [-1; +1]);
            testCase.verifyEqual(a.model.distribution, [0.75 0.25]);
        end

    end  
    
end

