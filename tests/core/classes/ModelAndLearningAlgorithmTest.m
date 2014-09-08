classdef ModelAndLearningAlgorithmTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function testValidModelInitialization(testCase)
            m = DummyModel('a', 'b', 0.5);
            testCase.verifyEqual(m.id, 'a');
            testCase.verifyEqual(m.name, 'b');
            testCase.verifyEqual(m.getParameter('p_req'), 0.5);
            testCase.verifyEqual(m.getParameter('p_opt'), 1);
            testCase.verifyEqual(m.getParameter('p_pv'), 3);

            m = DummyModel('a', 'b', 0.5, 'p_pv', 4);
            testCase.verifyEqual(m.id, 'a');
            testCase.verifyEqual(m.name, 'b');
            testCase.verifyEqual(m.getParameter('p_req'), 0.5);
            testCase.verifyEqual(m.getParameter('p_opt'), 1);
            testCase.verifyEqual(m.getParameter('p_pv'), 4);
        end

        function testInvalidModelInitialization(testCase)
            testCase.verifyError(@()DummyModel('a', 'b'), 'Lynx:Initialization:Parameters');
        end
        
        function testDefaultAlgorithm(testCase)
            m = DummyModel('a', 'b', 0.5);
            a = m.getDefaultTrainingAlgorithm();
            testCase.verifyEqual(class(a), 'DummyTrainingAlgorithm');
            testCase.verifyEqual(a.getParameter('p_req'), 0.5);
        end
        
        function testIncompatibleModel(testCase)
            m = DummyModelTwo('a', 'b');
            testCase.verifyError(@() DummyTrainingAlgorithm(m), 'Lynx:Runtime:ModelNotCompatible');
        end
        
        function testSetAndGetParameters(testCase)
            m = DummyModel('a', 'b', 0.5);
            a = m.getDefaultTrainingAlgorithm();
            a = a.setParameter('p_opt', 'b');
            testCase.verifyEqual(a.getParameter('p_opt'), 'b');
        end
        
        function testGetInvalidParameter(testCase)
            m = DummyModel('a', 'b', 0.5);
            testCase.verifyError(@() m.getParameter('t'), 'Lynx:Runtime:ParameterNotExisting');
        end
        
        function testTrainingAndTesting(testCase)
            m = DummyModel('a', 'b', 0.5);
            a = m.getDefaultTrainingAlgorithm();
            a = a.train(Dataset(RealMatrix([]), RealLabelsVector([1; 3; 2]), Tasks.R));
            testCase.verifyEqual(a.test(Dataset(RealMatrix([0.5; 1]), [], Tasks.R)), [3.5; 4.5]);
        end

    end  
    
end

