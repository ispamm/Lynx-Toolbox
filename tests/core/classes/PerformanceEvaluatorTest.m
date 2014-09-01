classdef PerformanceEvaluatorTest < matlab.unittest.TestCase
    
    methods(TestMethodSetup)
        function setup(testCase)
            PerformanceEvaluator.getInstance().clear();
            RegressionTask.getInstance().clear();
        end
    end
    
    methods(TestMethodTeardown)
        function teardown(testCase)
            PerformanceEvaluator.getInstance().clear();
            RegressionTask.getInstance().clear();
        end
    end
    
    methods (Test)
        
        function testPerformanceInitialization(testCase)
            p = PerformanceEvaluator.getInstance();
            testCase.assertEqual(class(p.getPrimaryPerformanceMeasure(Tasks.R)), 'MeanSquaredError');
            testCase.assertEqual(class(p.getPrimaryPerformanceMeasure(Tasks.BC)), 'MisclassificationError');
            testCase.assertEqual(class(p.getPrimaryPerformanceMeasure(Tasks.MC)), 'MisclassificationError');
            testCase.assertEmpty(p.getPrimaryPerformanceMeasure(Tasks.PR));
            testCase.assertEmpty(p.getPrimaryPerformanceMeasure(Tasks.ML));
        end
        
        function testChangePrimaryPerformanceMeasure(testCase)
            p = PerformanceEvaluator.getInstance();
            p.setPrimaryPerformanceMeasure(Tasks.ML, MeanAbsoluteError());
            testCase.assertEqual(class(p.getPrimaryPerformanceMeasure(Tasks.R)), 'MeanSquaredError');
            testCase.assertEqual(class(p.getPrimaryPerformanceMeasure(Tasks.BC)), 'MisclassificationError');
            testCase.assertEqual(class(p.getPrimaryPerformanceMeasure(Tasks.MC)), 'MisclassificationError');
            testCase.assertEmpty(p.getPrimaryPerformanceMeasure(Tasks.PR));
            testCase.assertEqual(class(p.getPrimaryPerformanceMeasure(Tasks.ML)), 'MeanAbsoluteError');
        end
        
        function testAddSecondaryPerformanceMeasures(testCase)
            p = PerformanceEvaluator.getInstance();
            testCase.assertEqual(length(p.getSecondaryPerformanceMeasures(Tasks.R)), 0);
            testCase.assertEqual(length(p.getSecondaryPerformanceMeasures(Tasks.BC)), 0);
            p.addSecondaryPerformanceMeasure(Tasks.R, MisclassificationError());
            s = p.getSecondaryPerformanceMeasures(Tasks.R);
            testCase.assertEqual(length(s), 1);
            testCase.assertEqual(length(p.getSecondaryPerformanceMeasures(Tasks.BC)), 0);
            testCase.assertEqual(class(s{1}), 'MisclassificationError');
            p.addSecondaryPerformanceMeasure(Tasks.R, ConfusionMatrix());
            s = p.getSecondaryPerformanceMeasures(Tasks.R);
            testCase.assertEqual(length(s), 2);
            testCase.assertEqual(length(p.getSecondaryPerformanceMeasures(Tasks.BC)), 0);
            testCase.assertEqual(class(s{1}), 'MisclassificationError');
            testCase.assertEqual(class(s{2}), 'ConfusionMatrix');
        end
        
        function testInvalidPerformanceMeasure(testCase)
            p = PerformanceEvaluator.getInstance();
            testCase.assertError(@() p.setPrimaryPerformanceMeasure(Tasks.R, 'test'), 'Lynx:Runtime:InvalidPerformance');
            testCase.assertError(@() p.setPrimaryPerformanceMeasure(Tasks.R, ConfusionMatrix()), 'Lynx:Runtime:InvalidPerformance');
            testCase.assertError(@() p.addSecondaryPerformanceMeasure(Tasks.R, 'test'), 'Lynx:Runtime:InvalidPerformance');
            testCase.assertWarningFree(@() p.addSecondaryPerformanceMeasure(Tasks.R, ConfusionMatrix()));
        end
        
    end  
    
end

