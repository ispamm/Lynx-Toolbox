% OnlineSequentialELM - Online Sequential Extreme Learning Machine
%   This is trained using a recursive least-square approach. For more
%   information, please refer to the following paper:
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

classdef OnlineSequentialELM < SequentialLearningAlgorithm
    
    properties
        M;  % Internal matrix
    end
    
    methods
        
        function obj = OnlineSequentialELM(model, varargin)
            obj = obj@SequentialLearningAlgorithm(model, varargin{:});
        end
        
        function p = initParameters(obj, p)
            p = obj.initParameters@SequentialLearningAlgorithm(p);
        end
        
        function obj = train_init(obj, dataset_init)
            
            % Get training data
            P0 = dataset_init.X.data;
            T0 = dataset_init.Y.data;
            
            [~, d] = size(P0);
            N_hidden = obj.getParameter('hiddenNodes');
            
            if(dataset_init.task == Tasks.MC)
                T0 = dummyvar(T0(:));
            end
            
            obj.model.outputWeights = rand(N_hidden, 1);
            obj.model = obj.model.generateWeights(d);
            
            H0 = obj.model.computeHiddenMatrix(P0);
            
            obj.M = pinv(H0' * H0);
            obj.model.outputWeights = pinv(H0) * T0;
            
        end
        
        function obj = train_step(obj, dataset_batch)
            
            % Get training data
            Pn = dataset_batch.X.data;
            Tn = dataset_batch.Y.data;
            
            if(dataset_batch.task == Tasks.MC)
                Tn = dummyvar(Tn(:));
            end
                
            H = obj.model.computeHiddenMatrix(Pn);
                
            obj.M = obj.M - obj.M * H' * (eye(size(Pn, 1)) + H * obj.M * H')^(-1) * H * obj.M;
            obj.model.outputWeights = obj.model.outputWeights + obj.M * H' * (Tn - H * obj.model.outputWeights);
            
        end
        
        function b = checkForCompatibility(~, model)
            b = model.isOfClass('ExtremeLearningMachine');
        end
        
    end
    
    methods(Static)
        function info = getDescription()
            info = 'Online Sequential Extreme Learning Machine trained using RLS. For more information, please refer to the following paper: Liang, Nan-Ying, et al. "A fast and accurate online sequential learning algorithm for feedforward networks." Neural Networks, IEEE Transactions on 17.6 (2006): 1411-1423.';
        end
        
        function pNames = getParametersNames()
            pNames = SequentialLearningAlgorithm.getParametersNames();
        end
        
        function pInfo = getParametersDescription()
            pInfo = SequentialLearningAlgorithm.getParametersDescription();
        end
        
        function pRange = getParametersRange()
            pRange = SequentialLearningAlgorithm.getParametersRange();
        end
    end
    
end

