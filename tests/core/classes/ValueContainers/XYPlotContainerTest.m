classdef XYPlotContainerTest < matlab.unittest.TestCase
    
    methods (Test)

        function testWithSingleInput(testCase)
            p = XYPlotContainer();
            p = p.store(XYPlot([1 2], [2 3]));
            p = p.computeFinalizedValue();
            testCase.verifyEqual(p.getFinalizedValue().X, [1 2]);
            testCase.verifyEqual(p.getFinalizedValue().Y, [2 3]);
        end
        
        function testWithTwoInputs(testCase)
            p = XYPlotContainer();
            p = p.store(XYPlot([1 2], [6 5]));
            p = p.store(XYPlot([3 2], [1 0]));
            p = p.computeFinalizedValue();
            testCase.verifyEqual(p.getFinalizedValue().X, [2 2]);
            testCase.verifyEqual(p.getFinalizedValue().Y, [3.5 2.5]);
        end
        
    end  
    
end

