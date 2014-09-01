classdef ChangeConfigurationTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function testTrainAndTestWithNoChange(testCase)
            SimulationLogger.getInstance().setAdditionalParameter('dataset_id', 'z');
            m = DummyModel('a', 'b', 0.5);
            a = m.getDefaultTrainingAlgorithm();
            a = ChangeConfiguration(a, 'w', {'p_req'}, {1});
            
            a = a.train([], [1; 3; 2]);
            testCase.verifyEqual(a.test([0.5; 1]), [3.5; 4.5]);
        end

        function testTrainAndTestWithChange(testCase)
            SimulationLogger.getInstance().setAdditionalParameter('dataset_id', 'w');
            m = DummyModel('a', 'b', 0.5);
            a = m.getDefaultTrainingAlgorithm();
            a = ChangeConfiguration(a, 'w', {'p_req'}, {1});
            
            a = a.train([], [1; 3; 2]);
            testCase.verifyEqual(a.test([0.5; 1]), [4; 5]);
        end

    end  
    
end

