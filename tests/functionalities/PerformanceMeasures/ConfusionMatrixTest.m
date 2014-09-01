classdef ConfusionMatrixTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function testPerformanceComparisonError(testCase)
            p = ConfusionMatrix();
            p = p.store(LabeledMatrix([1 2; 4 3]));
            testCase.verifyError(@()(p.isBetterThan(LabeledMatrix([5 4; 2 3]))), 'Lynx:Logical:PerformanceError');
        end
        
        function testPerformance(testCase)
            p = ConfusionMatrix();
            c = p.compute([1 -1 1], [1 1 -1], []);
            testCase.verifyEqual(c.matrix(), [0 1; 1 1]);
            testCase.verifyEqual(c.row_labels(), [-1 1]);
            testCase.verifyEqual(c.column_labels(), [-1 1]);
        end
        
    end  
    
end

