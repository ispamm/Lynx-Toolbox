classdef LabeledMatrixContainerTest < matlab.unittest.TestCase
    
    methods (Test)

        function testWithSingleInput(testCase)
            p = LabeledMatrixContainer();
            p = p.store(LabeledMatrix([1 0.3; 6 3]));
            p = p.computeFinalizedValue();
            testCase.verifyEqual(p.getFinalizedValue().matrix, [1 0.3; 6 3]);
        end
        
        function testWithTwoInputs(testCase)
            p = LabeledMatrixContainer();
            p = p.store(LabeledMatrix([1 0.3; 6 3]));
            p = p.store(LabeledMatrix([0.1 2; 1 6]));
            p = p.computeFinalizedValue();
            testCase.verifyEqual(p.getFinalizedValue().matrix, [0.55 1.15; 3.5 4.5]);
        end
        
    end  
    
end

