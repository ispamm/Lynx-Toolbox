classdef PercentageContainerTest < matlab.unittest.TestCase
    
    methods (Test)

        function testWithWrongInput(testCase)
            p = PercentageContainer();
            testCase.verifyError(@() p.store(1.1), 'Lynx:Validation:InvalidInput');
        end
        
        function testWithThreeSuccessiveInputs(testCase)
            p = PercentageContainer();
            p = p.store(0);
            p = p.store(0.5);
            testCase.verifyEqual(p.getFinalizedValue(), 0.25);
            p = p.store(1);
            testCase.verifyEqual(p.getFinalizedValue(), 0.5);
        end
        
        
        function testFormatForOutput(testCase)
            p = PercentageContainer();
            p = p.store(0.1);
            p = p.store(0.5);
            testCase.verifyEqual(p.formatForOutput(), '30.00% (+/- 20.00%)');
        end
        
    end  
    
end

