classdef ChangeConfigurationTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function testTrainAndTestWithNoChange(testCase)
            m = DummyModel('a', 'b', 0.5);
            a = m.getDefaultTrainingAlgorithm();
            a = ChangeConfiguration(a, 'w', {'p_req'}, {1});
            d = Dataset(RealMatrix([]), RealLabelsVector([1; 3; 2]), Tasks.MC);
            d = d.setIdAndName('r', '');
            a = a.train(d);
            testCase.verifyEqual(a.test(Dataset(RealMatrix([0.5; 1]), [], Tasks.MC)), [3.5; 4.5]);
        end

        function testTrainAndTestWithChange(testCase)
            m = DummyModel('a', 'b', 0.5);
            a = m.getDefaultTrainingAlgorithm();
            a = ChangeConfiguration(a, 'w', {'p_req'}, {1});
            
            d = Dataset(RealMatrix([0.5; 1]), RealLabelsVector([1; 3; 2]), Tasks.MC);
            
            d = d.setIdAndName('w', '');
            a = a.train(d);
            testCase.verifyEqual(a.test(d), [4; 5]);
        end

    end  
    
end

