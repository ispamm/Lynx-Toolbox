classdef MulticlassClassificationTaskTest < matlab.unittest.TestCase
    
    methods(TestMethodSetup)
        
        function setup(testCase)
            MulticlassClassificationTask.getInstance().clear();
        end
        
    end
    
    methods(TestMethodTeardown)
        function teardown(testCase)
            MulticlassClassificationTask.getInstance().clear();
        end
    end
    
    methods (Test)
        
        function testForSingleton(testCase)
            testCase.verifyError(@() MulticlassClassificationTask(), 'MATLAB:class:MethodRestricted');
        end
        
        function testForAssociatedObjects(testCase)
            b = MulticlassClassificationTask.getInstance();
            testCase.verifyEqual(class(b.getPerformanceMeasure()), 'MisclassificationError');
            testCase.verifyEqual(class(b.getDatasetFactory()), 'DummyDatasetFactory');
            testCase.verifyEqual(b.getDescription(), 'Multiclass classification');
        end
        
        function testForAddingFolder(testCase)
            MulticlassClassificationTask.getInstance().addFolder('tests/dummydatasets');
            testCase.verifyEqual(length(MulticlassClassificationTask.getInstance().folders), 2);
            MulticlassClassificationTask.getInstance().addFolder('core');
            testCase.verifyEqual(length(MulticlassClassificationTask.getInstance().folders), 3);
        end
        
        function testDatasetNotFound(testCase)
            o = MulticlassClassificationTask.getInstance().loadDataset('valid_MC');
            testCase.verifyEmpty(o);
        end
        
        function testValidDataset(testCase)
            MulticlassClassificationTask.getInstance().addFolder('tests/dummydatasets');
            o = MulticlassClassificationTask.getInstance().loadDataset('valid_MC', 'a');
            testCase.verifyEqual(o.X, [1 2 3; 4 5 6]');
            testCase.verifyEqual(o.Y, [1; 2; 1]);
        end
        
        function testInvalidDataset(testCase)
            MulticlassClassificationTask.getInstance().addFolder('tests/dummydatasets');
            testCase.verifyError(@()MulticlassClassificationTask.getInstance().loadDataset('invalid_MC_Y', 'a'), 'Lynx:Initialization:InvalidDataset');
            testCase.verifyError(@()MulticlassClassificationTask.getInstance().loadDataset('invalid_MC_Y_2', 'a'), 'Lynx:Initialization:InvalidDataset');
            testCase.verifyError(@()MulticlassClassificationTask.getInstance().loadDataset('invalid_MC_info', 'a'), 'Lynx:Initialization:InvalidDataset');
        end
       
    end  
    
end

