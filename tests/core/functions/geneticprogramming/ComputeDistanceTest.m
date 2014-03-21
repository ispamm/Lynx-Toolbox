classdef ComputeDistanceTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function testBothTerminalNodes(testCase)
            % Same terminal nodes
            d = computeDistance(GaussKernel(2), GaussKernel(4));
            testCase.verifyEqual(d, 0);
            % Different terminal nodes
            d = computeDistance(HyperbolicKernel(0,2), GaussKernel(1));
            testCase.verifyEqual(d, 1);
        end
        
        function testTerminalNodeAndComplexNode(testCase)
            % Terminal node and unary operator
            d = computeDistance(GaussKernel(1), ShiftingOperator(GaussKernel(2),[], 2));
            testCase.verifyEqual(d, 1.5);
            % Same as before, switched
            d = computeDistance(ShiftingOperator(GaussKernel(2),[], 2), GaussKernel(1));
            testCase.verifyEqual(d, 1.5);
            % Terminal node and binary operator
            d = computeDistance(PlusOperator(GaussKernel(2), PolyKernel(4)), GaussKernel(1));
            testCase.verifyEqual(d, 2);
            % Terminal node and complex node of depth 3
            d = computeDistance(PlusOperator(ScalingOperator(GaussKernel(2),[], 1), PolyKernel(4)), GaussKernel(1));
            testCase.verifyEqual(d, 2.25);
        end
        
        function testBothComplexNodesDepthTwo(testCase)
            % Same unary operators, same child
            d = computeDistance(ShiftingOperator(GaussKernel(2),[], 2), ShiftingOperator(GaussKernel(2),[], 2));
            testCase.verifyEqual(d, 0);
            % Same unary operators, different child
            d = computeDistance(ShiftingOperator(GaussKernel(2),[], 2), ShiftingOperator(PolyKernel(2),[], 2));
            testCase.verifyEqual(d, 0.5);
            % Same binary operators, same childs
            d = computeDistance(PlusOperator(GaussKernel(2), PolyKernel(4)), PlusOperator(GaussKernel(2), PolyKernel(4)));
            testCase.verifyEqual(d, 0);
            % Same binary operators, only one equal child
            d = computeDistance(MultOperator(GaussKernel(2), PolyKernel(4)), MultOperator(PolyKernel(2), PolyKernel(4)));
            testCase.verifyEqual(d, 0.5);
            % Same binary operators, different childs
            d = computeDistance(MultOperator(GaussKernel(2), GaussKernel(4)), MultOperator(PolyKernel(2), PolyKernel(4)));
            testCase.verifyEqual(d, 1);
        end
        
        function testBothComplexNodesDepthThree(testCase)
            d = computeDistance(MultOperator(ScalingOperator(GaussKernel(3),[], 3), PolyKernel(4)), MultOperator(PolyKernel(2), PolyKernel(4)));
            testCase.verifyEqual(d, 0.75);
            d = computeDistance(MultOperator(ScalingOperator(GaussKernel(3),[], 3), PolyKernel(4)), PlusOperator(PolyKernel(2), PolyKernel(4)));
            testCase.verifyEqual(d, 1.75);
            d = computeDistance(MultOperator(PlusOperator(GaussKernel(3),HyperbolicKernel(0.5, 0.1)), PolyKernel(4)), PlusOperator(PolyKernel(2), PolyKernel(4)));
            testCase.verifyEqual(d, 2);
        end
        
    end
    
end

