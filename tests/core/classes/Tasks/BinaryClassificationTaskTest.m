classdef BinaryClassificationTaskTest < matlab.unittest.TestCase
    
    methods(TestMethodSetup)
        
        function setup(testCase)
            BinaryClassificationTask.getInstance().clear();
        end
        
    end
    
    methods(TestMethodTeardown)
        function teardown(testCase)
            BinaryClassificationTask.getInstance().clear();
        end
    end
    
    methods (Test)
        
        function testForSingleton(testCase)
            testCase.verifyError(@() BinaryClassificationTask(), 'MATLAB:class:MethodRestricted');
        end
        
        function testForAssociatedObjects(testCase)
            b = BinaryClassificationTask.getInstance();
            testCase.verifyEqual(class(b.getPerformanceMeasure()), 'MisclassificationError');
            testCase.verifyEqual(class(b.getDatasetFactory()), 'DummyDatasetFactory');
            testCase.verifyEqual(b.getDescription(), 'Binary classification');
        end
        
        function testForAddingFolder(testCase)
            BinaryClassificationTask.getInstance().addFolder('test/dummydatasets');
            testCase.verifyEqual(length(BinaryClassificationTask.getInstance().folders), 2);
            BinaryClassificationTask.getInstance().addFolder('core');
            testCase.verifyEqual(length(BinaryClassificationTask.getInstance().folders), 3);
        end
        
        function testDatasetNotFound(testCase)
            o = BinaryClassificationTask.getInstance().loadDataset('valid_BC');
            testCase.verifyEmpty(o);
        end
        
        function testValidDataset(testCase)
            BinaryClassificationTask.getInstance().addFolder('tests/dummydatasets');
            o = BinaryClassificationTask.getInstance().loadDataset('valid_BC', 'a');
            testCase.verifyEqual(o.X, [1 2 3; 4 5 6]);
            testCase.verifyEqual(o.Y, [1; -1]);
        end
        
        function testInvalidDataset(testCase)
            BinaryClassificationTask.getInstance().addFolder('tests/dummydatasets');
            testCase.verifyError(@()BinaryClassificationTask.getInstance().loadDataset('invalid_BC_Y', 'a'), 'Lynx:Initialization:InvalidDataset');
            testCase.verifyError(@()BinaryClassificationTask.getInstance().loadDataset('invalid_BC_info', 'a'), 'Lynx:Initialization:InvalidDataset');
        end
       
    end  
    
end

