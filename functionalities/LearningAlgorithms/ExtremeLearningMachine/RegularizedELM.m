% RegularizedELM - Train a ELM model using a regularized linear regression
%   This is detailed in the paper:
%
%   [1] Huang, Guang-Bin, et al. 'Extreme learning machine for
%   regression and multiclass classification.'' Systems, Man, and
%   Cybernetics, Part B: Cybernetics, IEEE Transactions on 42.2 (2012):
%   513-529.
%
%   The only parameter is a regularization factor:
%
%   add_algorithm('ELM', 'ELM', @ExtremeLearningMachine, 'C', 10)
%   changes the regularization parameter.
%
%   The main operation for training is a hiddenNodes x hiddenNodes
%   matrix inversion, that can be parallelized on the GPU.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef RegularizedELM < LearningAlgorithm
    
    properties
    end
    
    methods
        
        function obj = RegularizedELM(model, varargin)
            obj = obj@LearningAlgorithm(model, varargin{:});
        end
        
        function p = initParameters(~, p)
            p.addParamValue('C', 1, @(x) assert(x > 0, 'Regularization parameter of RegularizedELM must be > 0'));
        end
        
        function obj = train(obj, Xtr, Ytr)
            
            [N, d] = size(Xtr);
            
            N_hidden = obj.getParameter('hiddenNodes');
            
            if(obj.getCurrentTask() == Tasks.MC)
                Ytr  = dummyvar(Ytr);
            end

            if(isa(Xtr, 'gpuArray'))
                obj.model.weightsl1 = gpuArray.rand(N_hidden, d)*2-1;
                obj.model.biasl1 = gpuArray.rand(N_hidden,1)*2-1;
            else
                obj.model = obj.model.generateWeights(d);
            end
            
            H = obj.model.computeHiddenMatrix(Xtr);
            
            if(N >= N_hidden)
                outputWeightsCopy = (eye(N_hidden)./obj.parameters.C + H' * H) \ ( H' * Ytr );
            else
                outputWeightsCopy = H'*inv(eye(size(H, 1))./obj.parameters.C + H * H') *  Ytr ;
            end
            
            clear H
             
            if(isa(outputWeightsCopy, 'gpuArray'))
                outputWeightsCopy = gather(outputWeightsCopy);
                obj.model.biasl1 = gather(obj.model.biasl1);
                obj.model.weightsl1 = gather(obj.model.weightsl1);
            end
            
            obj.model.outputWeights = outputWeightsCopy;
            
        end

        function b = checkForCompatibility(~, model)
            b = model.isOfClass('ExtremeLearningMachine');
        end

        function b = hasGPUSupport(obj)
            b = false;
        end
    end
    
    methods(Static)

        function info = getDescription()
            info = ['Extreme Learning Machine trained using L2-regularized ridge regression. For more information, ' ...
                'please refer to the following paper: Huang, Guang-Bin, et al. ''Extreme learning machine for regression and multiclass classification.'' Systems, Man, and Cybernetics, Part B: Cybernetics, IEEE Transactions on 42.2 (2012): 513-529.'];
        end
        
        function pNames = getParametersNames()
            pNames = {'C'}; 
        end
        
        function pInfo = getParametersDescription()
            pInfo = {'Regularization factor'};
        end
        
        function pRange = getParametersRange()
            pRange = {'Positive real number, default is 1'};
        end    
    end
    
end

