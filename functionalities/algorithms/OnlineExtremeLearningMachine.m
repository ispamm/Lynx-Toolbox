classdef OnlineExtremeLearningMachine < LearningAlgorithm
    % ONLINEEXTREMELEARNINGMACHINE Online Sequential Extreme Learning 
    %   Machine trained using RLS. For more information, please refer to 
    %   the following paper: 
    %
    %   [1] Liang, Nan-Ying, et al. "A fast and accurate online sequential
    %   learning algorithm for feedforward networks." Neural Networks, IEEE
    %   Transactions on 17.6 (2006): 1411-1423.
    %
    %   This has the same training parameters as the standard ELM, plus two
    %   additional ones: N0 (size of the initial block) and blockSize (size
    %   of the mini-batch).
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it

    properties
        weights_l1;
        bias_l1;
        outputWeights;
    end
    
    methods
        
        function obj = OnlineExtremeLearningMachine(varargin)
            obj = obj@LearningAlgorithm(varargin);
        end
        
        function initParameters(~, p)
            p.addParamValue('hiddenNodes', 50, @(x) assert(mod(x,1) == 0 && x > 0, 'Hidden nodes of ELM must be an integer > 0'));
            p.addParamValue('C', 1, @(x) assert(x > 0, 'Regularization parameter of RN must be > 0'));
            p.addParamValue('type', 'rbf', @(x) assert(ischar(x), 'Type of OS-ELM must be a string'));
            p.addParamValue('N0', 15);
            p.addParamValue('blockSize', 15);
        end
        
        function obj = train(obj, Xtr, Ytr)

            [N d] = size(Xtr);
            N_hidden = obj.trainingParams.hiddenNodes;
            
            if(obj.getTask() == Tasks.MC)
                Ytr = dummyvar(Ytr(:));
            end

            obj.outputWeights = rand(N_hidden, 1);
            M = rand(N_hidden, N_hidden);
            obj.weights_l1 = rand(N_hidden, d)*2-1;

            switch lower(obj.trainingParams.type)
                case{'rbf'}
                    obj.bias_l1 = rand(1,N_hidden);
            end

            if(obj.trainingParams.N0 > 0)

                P0 = Xtr(1:obj.trainingParams.N0,:); 
                T0 = Ytr(1:obj.trainingParams.N0,:);

                switch lower(obj.trainingParams.type)
                    case{'rbf'}
                    H0 = rbffun(P0,obj.weights_l1,obj.bias_l1);
                end
                M = pinv(H0' * H0);
                obj.outputWeights = pinv(H0) * T0;
                clear P0 T0 H0;
    
            else
                obj.trainingParams.N0 = 1; 
            end

            for n = obj.trainingParams.N0 : obj.trainingParams.blockSize : N
                if (n+obj.trainingParams.blockSize-1) > N
                    Pn = Xtr(n:N,:);
                    Tn = Ytr(n:N,:);
                    obj.trainingParams.blockSize = size(Pn,1);
                    clear V;
                else
                    Pn = Xtr(n:(n+obj.trainingParams.blockSize-1),:);
                    Tn = Ytr(n:(n+obj.trainingParams.blockSize-1),:);
                end
    
                switch lower(obj.trainingParams.type)
                    case{'rbf'}
                        H = rbffun(Pn,obj.weights_l1,obj.bias_l1);
                end 
   
                M = M - M * H' * (eye(obj.trainingParams.blockSize) + H * M * H')^(-1) * H * M;
                obj.outputWeights = obj.outputWeights + M * H' * (Tn - H * obj.outputWeights);
    
            end
        end
        
        function [labels, scores] = test(obj, Xts)
            
            switch lower(obj.trainingParams.type)
                case{'rbf'}
                    HTest = rbffun(Xts(:,:), obj.weights_l1, obj.bias_l1);
            end   

            scores = HTest * obj.outputWeights;
            clear HTest;

            labels = convert_scores(scores, obj.getTask());

        end
        
        function res = isTaskAllowed(~, ~)
            res = true;
        end
    end
    
    methods(Static)
        function info = getInfo()
            info = 'Online Sequential Extreme Learning Machine trained using RLS. For more information, please refer to the following paper: Liang, Nan-Ying, et al. "A fast and accurate online sequential learning algorithm for feedforward networks." Neural Networks, IEEE Transactions on 17.6 (2006): 1411-1423.';
        end
        
        function pNames = getParametersNames()
            pNames = {'hiddenNodes', 'C', 'type', 'N0', 'blockSize'}; 
        end
        
        function pInfo = getParametersInfo()
            pInfo = {'Number of hidden nodes', 'Regularization factor', 'Family of hidden nodes', ...
                'Size of initial block', 'Size of batches'};
        end
        
        function pRange = getParametersRange()
            pRange = {'Integer > 0, default is 50', 'Positive real number, default is 1', 'String in {rbf}, default is rbf', ...
                'Positive integer, default is 15', 'Positive integer, default is 15'};
        end 
    end
    
end

