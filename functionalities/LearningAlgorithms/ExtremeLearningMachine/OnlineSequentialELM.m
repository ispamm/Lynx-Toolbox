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

classdef OnlineSequentialELM < LearningAlgorithm
    
    methods
        
        function obj = OnlineSequentialELM(model, varargin)
            obj = obj@LearningAlgorithm(model, varargin{:});
        end
        
        function p = initParameters(obj, p)
            p.addParamValue('N0', 15, @(x) assert(isnatural(x, false), 'Initial block size of OS-ELM must be a non-zero natural number'));
            p.addParamValue('blockSize', 15, @(x) assert(isnatural(x, false), 'Block size of OS-ELM must be a non-zero natural number'));
        end
        
        function obj = train(obj, Xtr, Ytr)
            
            [N, d] = size(Xtr);
            N_hidden = obj.getParameter('hiddenNodes');
            
            if(obj.getCurrentTask() == Tasks.MC)
                Ytr = dummyvar(Ytr(:));
            end
            
            obj.model.outputWeights = rand(N_hidden, 1);
            M = rand(N_hidden, N_hidden);
            obj.model = obj.model.generateWeights(d);
            
            P0 = Xtr(1:obj.parameters.N0,:);
            T0 = Ytr(1:obj.parameters.N0,:);
            
            H0 = obj.model.computeHiddenMatrix(P0);
            
            M = pinv(H0' * H0);
            obj.model.outputWeights = pinv(H0) * T0;
            clear P0 T0 H0;
            
            for n = obj.parameters.N0 : obj.parameters.blockSize : N
                if (n+obj.parameters.blockSize-1) > N
                    Pn = Xtr(n:N,:);
                    Tn = Ytr(n:N,:);
                    obj.parameters.blockSize = size(Pn,1);
                    clear V;
                else
                    Pn = Xtr(n:(n+obj.parameters.blockSize-1),:);
                    Tn = Ytr(n:(n+obj.parameters.blockSize-1),:);
                end
                
                H = obj.model.computeHiddenMatrix(Pn);
                
                M = M - M * H' * (eye(obj.parameters.blockSize) + H * M * H')^(-1) * H * M;
                obj.model.outputWeights = obj.model.outputWeights + M * H' * (Tn - H * obj.model.outputWeights);
                
            end
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
            pNames = {'N0', 'blockSize'};
        end
        
        function pInfo = getParametersDescription()
            pInfo = {'Size of initial block', 'Size of batches'};
        end
        
        function pRange = getParametersRange()
            pRange = {'Positive integer, default is 15', 'Positive integer, default is 15'};
        end
    end
    
end

