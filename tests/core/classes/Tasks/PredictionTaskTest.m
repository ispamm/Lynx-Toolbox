classdef PredictionTaskTest < matlab.unittest.TestCase
    
    methods(TestMethodSetup)
        
        function setup(testCase)
            PredictionTask.getInstance().clear();
        end
        
    end
    
    methods(TestMethodTeardown)
        function teardown(testCase)
            PredictionTask.getInstance().clear();
        end
    end
    
    methods (Test)
        
        function testForSingleton(testCase)
            testCase.verifyError(@() PredictionTask(), 'MATLAB:class:MethodRestricted');
        end
        
        function testForAssociatedObjects(testCase)
            b = PredictionTask.getInstance();
            testCase.verifyEqual(class(b.getDatasetFactory()), 'EmbedTimeseriesFactory');
            testCase.verifyEqual(b.getDescription(), 'Prediction');
        end
        
        function testForAddingFolder(testCase)
            PredictionTask.getInstance().addFolder('tests/dummydatasets');
            testCase.verifyEqual(length(PredictionTask.getInstance().folders), 2);
            PredictionTask.getInstance().addFolder('core');
            testCase.verifyEqual(length(PredictionTask.getInstance().folders), 3);
        end
        
        function testDatasetNotFound(testCase)
            o = PredictionTask.getInstance().loadDataset('valid_PR');
            testCase.verifyEmpty(o);
        end
        
        function testValidDataset(testCase)
            PredictionTask.getInstance().addFolder('tests/dummydatasets');
            o = PredictionTask.getInstance().loadDataset('valid_PR', 'a');
            testCase.verifyEqual(o.X, (1:10)');
            f = PredictionTask.getInstance().getDatasetFactory();
            
            evalc('d = f.create(Tasks.PR, ''a'', ''a'', o);');
            testCase.verifyEqual(d{1}.X, [1:7; 2:8; 3:9]);
            testCase.verifyEqual(d{1}.Y, [8; 9; 10]);
            testCase.verifyEqual(d{1}.task, Tasks.R);
            
            f = EmbedTimeseriesFactory(6, 1);
            evalc('d = f.create(Tasks.PR, ''a'', ''a'', o);');
            testCase.verifyEqual(d{1}.X, [1:6; 2:7; 3:8; 4:9]);
            testCase.verifyEqual(d{1}.Y, [7; 8; 9; 10]);
            testCase.verifyEqual(d{1}.task, Tasks.R);
            
            f = EmbedTimeseriesFactory(7, 2);
            evalc('d = f.create(Tasks.PR, ''a'', ''a'', o);');
            testCase.verifyEqual(d{1}.X, [1:7; 2:8]);
            testCase.verifyEqual(d{1}.Y, [9; 10]);
            testCase.verifyEqual(d{1}.task, Tasks.R);
            
        end
        
        function testInvalidDataset(testCase)
            PredictionTask.getInstance().addFolder('tests/dummydatasets');
            testCase.verifyError(@()PredictionTask.getInstance().loadDataset('invalid_BC_Y', 'a'), 'Lynx:Initialization:InvalidDataset');
            testCase.verifyError(@()PredictionTask.getInstance().loadDataset('invalid_BC_info', 'a'), 'Lynx:Initialization:InvalidDataset');
        end
       
    end  
    
end

