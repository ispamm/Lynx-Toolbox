classdef TournamentTest < matlab.unittest.TestCase
    
    properties
        population;
    end
    
    methods(TestMethodSetup)
        function initPopulationAndFitness(testCase)
            testCase.population = cell(3,1);
            testCase.population{1} = ShiftingOperator(GaussKernel(3), [], 1);
            testCase.population{2} = PlusOperator(PolyKernel(3), HyperbolicKernel(1,1));
            testCase.population{3} = PolyKernel(1);
        end
    end
    
    methods (Test)
        
        function testTournamentDifferentFitness(testCase)
            ind = tournament(testCase.population, [0.1 0.2 0.3], 3);
            testCase.verifyTrue(isa(ind, 'ShiftingOperator'));
            ind = tournament(testCase.population, [0.1 0.05 0.3], 3);
            testCase.verifyTrue(isa(ind, 'PlusOperator'));
        end
        
        function testTournamentSameFitness(testCase)
            ind = tournament(testCase.population, [0.1 0.1 0.3], 3);
            testCase.verifyTrue(isa(ind, 'ShiftingOperator'));
            ind = tournament(testCase.population, [0.2 0.05 0.05], 3);
            testCase.verifyTrue(isa(ind, 'PolyKernel'));
        end
        
    end
    
end

