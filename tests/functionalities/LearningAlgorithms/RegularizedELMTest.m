classdef RegularizedELMTest < matlab.unittest.TestCase
    
    methods (Test)

        function testTrainingAndTesting(testCase)
            m = ExtremeLearningMachine('', '', 'hiddenNodes', 2, 'type', 'sigmoid');
            a = m.getDefaultTrainingAlgorithm();
            
            [weights,biases] = get_next_prns(@rand, {[2 3], [2 1]});
            weights = weights*2 - 1;
            biases = biases*2 - 1;

            X = [1 1 1; 1 1 1];
            Y = [1; -1];
            
            H = 1./(1 + exp(-weights*X' - repmat(biases, 1, 2)));
            H = H';
            outWeights = H'*inv(eye(size(H, 1)) + H * H') *  Y ;
            
            a = a.train(Dataset(RealMatrix(X),BinaryLabelsVector(Y), Tasks.BC));
            
            testCase.assertLessThan(abs((H*outWeights) -  a.test(Dataset(RealMatrix(X), [], Tasks.BC))), 10^-10);
            
        end

    end  
    
end

