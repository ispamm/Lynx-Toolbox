% SemiSupervisedLearningAlgorithm - An abstract class for implementing semi-supervised learning algorithms
%   These are trained by supplementing an additional unlabeled training
%   dataset.
%
% SemiSupervisedLearningAlgorithm Methods:
%
%   train_semisupervised - Takes an Nxd input matrix Xtr, and
%   associated labels Ytr, an additional unlabeled input matrix Mxd,
%   and trains its internal model.
%
%   train - Calls train_semisupervised, using as additional data a
%   matrix taken from the SimulationLogger under the name 'Xu'.
%
%   See also LEARNINGALGORITHM

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef SemiSupervisedLearningAlgorithm < LearningAlgorithm
    
    properties            
    end
    
    methods(Abstract=true)
        % Train the model
        obj = train_semisupervised(obj, dtrain, dunsupervised)
    end
    
    methods

       function obj = SemiSupervisedLearningAlgorithm(model, varargin)
           obj = obj@LearningAlgorithm(model, varargin{:});
       end
       
       function obj = train(obj, dtrain)
            log = SimulationLogger.getInstance();
            obj = obj.train_semisupervised(dtrain, log.getAdditionalParameter('d_unsupervised'));
        end
             
    end
    
end

