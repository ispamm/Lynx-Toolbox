classdef RegressionTaskTest < matlab.unittest.TestCase
    
    methods(TestMethodSetup)
        
        function setup(testCase)
            RegressionTask.getInstance().clear();
        end
        
    end
       
    methods(TestMethodTeardown)
        function teardown(testCase)
            RegressionTask.getInstance().clear();
        end
    end
    
    methods (Test)
        
        function testForSingleton(testCase)
            testCase.verifyError(@() RegressionTask(), 'MATLAB:class:MethodRestricted');
        end
        
        function testForAssociatedObjects(testCase)
            b = RegressionTask.getInstance();
            testCase.verifyEqual(class(b.getPerformanceMeasure()), 'MeanSquaredError');
            testCase.verifyEqual(class(b.getDatasetFactory()), 'DummyDatasetFactory');
            testCase.verifyEqual(b.getDescription(), 'Regression');
        end
        
        function testForAddingFolder(testCase)
            RegressionTask.getInstance().addFolder('tests/dummydatasets');
            testCase.verifyEqual(length(RegressionTask.getInstance().folders), 2);
            RegressionTask.getInstance().addFolder('core');
            testCase.verifyEqual(length(RegressionTask.getInstance().folders), 3);
        end
        
        function testDatasetNotFound(testCase)
            o = RegressionTask.getInstance().loadDataset('valid_BC');
            testCase.verifyEmpty(o);
        end
        
        function testValidDataset(testCase)
            RegressionTask.getInstance().addFolder('tests/dummydatasets');
            o = RegressionTask.getInstance().loadDataset('valid_BC', 'a');
            testCase.verifyEqual(o.X, [1 2 3; 4 5 6]);
            testCase.verifyEqual(o.Y, [1; -1]);
        end
        
        function testInvalidDataset(testCase)
            RegressionTask.getInstance().addFolder('tests/dummydatasets');
            testCase.verifyError(@()RegressionTask.getInstance().loadDataset('invalid_BC_info', 'a'), 'Lynx:Initialization:InvalidDataset');
        end
       
    end  
    
end

