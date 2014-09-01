classdef SimulationLoggerTest < matlab.unittest.TestCase
    
    properties
       log; 
    end
    
    methods(TestMethodSetup)
        function initSimulationLogger(testCase)
            SimulationLogger.getInstance().clear();
            testCase.log = SimulationLogger.getInstance();
        end
    end
    
    methods (Test)
        
        % Test the get method, with a non-existing parameter, and a
        % previously inserted one
        function testGetAdditionalParameter(testCase)
            l = testCase.log.getAdditionalParameter('prova');
            testCase.verifyEmpty(l);
            testCase.log.setAdditionalParameter('prova', 3);
            l = testCase.log.getAdditionalParameter('prova');
            testCase.verifyEqual(l, 3);
        end
        
        % Test the append method
        function testAppendAdditionalParameter(testCase)
            testCase.log.setAdditionalParameter('prova', 2);
            testCase.log.appendToAdditionalParameter('prova', 1);
            l = testCase.log.getAdditionalParameter('prova');
            testCase.verifyTrue(iscell(l));
            testCase.verifyEqual(length(l), 2);
            testCase.verifyEqual(l{1}, 2);
            testCase.verifyEqual(l{2}, 1);
            testCase.log.appendToAdditionalParameter('prova', 5);
            l = testCase.log.getAdditionalParameter('prova');
            testCase.verifyEqual(length(l), 3);
            testCase.verifyEqual(l{1}, 2);
            testCase.verifyEqual(l{2}, 1);
            testCase.verifyEqual(l{3}, 5);
        end

    end  
    
end

