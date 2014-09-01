classdef SingletonClassTest < matlab.unittest.TestCase
    
    methods(TestMethodSetup)
        
        function setup(testCase)
            BinaryClassificationTask.getInstance().clear();
            MulticlassClassificationTask.getInstance().clear();
        end
        
    end
    
    methods(TestMethodTeardown)
        
        function teardown(testCase)
            BinaryClassificationTask.getInstance().clear();
            MulticlassClassificationTask.getInstance().clear();
        end
        
    end
    
    methods (Test)
        
        function testDifferentSingletons(testCase)
            BinaryClassificationTask.getInstance().addFolder('dummydatasets');
            testCase.verifyEqual(length(MulticlassClassificationTask.getInstance().folders), 1);
        end
        
        function testClearSingleton(testCase)
            BinaryClassificationTask.getInstance().addFolder('dummydatasets');
            MulticlassClassificationTask.getInstance().addFolder('dummydatasetsMC');
            testCase.verifyEqual(length(BinaryClassificationTask.getInstance().folders), 2);
            testCase.verifyEqual(length(MulticlassClassificationTask.getInstance().folders), 2);
            BinaryClassificationTask.getInstance().clear();
            testCase.verifyEqual(length(BinaryClassificationTask.getInstance().folders), 1);
            testCase.verifyEqual(length(MulticlassClassificationTask.getInstance().folders), 2);
        end
        
    end  
    
end

