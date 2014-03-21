classdef SimulationLoggerTest < matlab.unittest.TestCase
    
    properties
       log; 
    end
    
    methods(TestMethodSetup)
        function initSimulationLogger(testCase)
            SimulationLogger.getInstance().clear();
            testCase.log = SimulationLogger.getInstance();
            testCase.log.datasets{1} = Dataset('id1', 'name1', Tasks.R, [], []);
            testCase.log.datasets{2} = Dataset('id2', 'name2', Tasks.R, [], []);
            testCase.log.datasets{3} = Dataset('altroid', 'name3', Tasks.R, [], []);
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
        
        % Test the findDatasetById method
        function testFindDatasetById(testCase)
            testCase.verifyError(@()testCase.log.findDatasetById('stranoid'), 'LearnTool:Validation:DatasetNotDeclared');
            n = testCase.log.findDatasetById('id2');
            testCase.verifyEqual(n, 2);
        end
        
        % Test the findDatasetByIdWithRegexp method
        function testFindDatasetByIdWithRegexp(testCase)
            ids = testCase.log.findDatasetByIdWithRegexp('stranoid');
            testCase.verifyEmpty(ids);
            ids = testCase.log.findDatasetByIdWithRegexp('altroid');
            testCase.verifyEqual(ids, 3);
            ids = testCase.log.findDatasetByIdWithRegexp('id.*');
            testCase.verifyEqual(ids, [1;2]);
        end
        
    end  
    
end

