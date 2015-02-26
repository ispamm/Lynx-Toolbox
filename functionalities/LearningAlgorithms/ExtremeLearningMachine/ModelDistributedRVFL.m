% ModelDistributedRVFL - RVFL training with distributed features
%   This algorithm is used to train an RVFL net, when the features are
%   distributed throughout a networks of agents. To this end, it computes a
%   random vector expansion locally, followed by a global linear regression
%   using the ADMM optimization strategy. See the following link for more
%   information:
%   http://ispac.ing.uniroma1.it/scardapane/software/lynx/heterogeneous-sources/

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef ModelDistributedRVFL < DistributedLearningAlgorithm
    
    properties
        local_models;   % Local models for storing hidden functions
    end
    
    methods
        
        function obj = ModelDistributedRVFL(model, varargin)
            obj = obj@DistributedLearningAlgorithm(model, varargin{:});
        end
        
        function p = initParameters(~, p)
            p.addParamValue('C', 1, @(x) assert(x > 0, 'Regularization parameter of ModelDistributedRVFL must be > 0'));
            p.addParamValue('consensus_max_steps', 300);
            p.addParamValue('consensus_thres', 0.001);
            p.addParamValue('admm_max_steps', 300);
            p.addParamValue('admm_rho', 1);
            p.addParamValue('admm_reltol', 0.001);
            p.addParamValue('admm_abstol', 0.001);
        end
        
        function obj = train_locally(obj, d)
            
            % Auxiliary variables
            N_hidden = obj.getParameter('hiddenNodes');
            N_nodes = obj.topology.N;
            N_samples = size(d.X.data, 1);

            if(d.task == Tasks.MC)
                y = dummyvar(d.Y.data);
                nLabels = max(d.Y.data);
                beta = zeros(N_hidden, nLabels, N_nodes);
                Hbeta_curr = zeros(N_samples, nLabels, N_nodes);
                % Strange cell array to index conditionally either the 
                % first 2 dimensions or only the first.
                idx = {':', ':'};
            else
                y = d.Y.data;
                nLabels = 1;
                beta = zeros(N_hidden, N_nodes);
                idx = {':'};
            end

            % Get the logger
            s = SimulationLogger.getInstance();

            % Global terms
            z = zeros(N_samples, nLabels);
            t = zeros(N_samples, nLabels);
            Hbeta_avg = zeros(N_samples, nLabels);
            r_tmp = zeros(N_samples, nLabels);
            
            % Parameters
            rho = obj.getParameter('admm_rho');
            steps = obj.getParameter('admm_max_steps');
            
            % Initialize statistics
            obj.statistics.r_norm = zeros(steps, 1);
            
            % Precompute the inverse matrices
            Hi = cell(N_nodes, 1);
            Hinv = cell(N_nodes, 1);
            
            for ii = 1:N_nodes
                
                d_local = obj.getLocalPart(d, ii);
                Xtr = d_local.X.data;
                
                Hi{ii} = obj.local_models{ii}.computeHiddenMatrix(Xtr);
                
                % TODO: Insert other formulation
                Hinv{ii} = ((obj.getParameter('C')/rho)*eye(N_hidden) + Hi{ii}'*Hi{ii})\Hi{ii}';
                
            end
            
            if steps == 0
               
                for jj = 1:N_nodes
                    obj.local_models{jj}.outputWeights = (obj.getParameter('C')*eye(N_hidden) + Hi{ii}'*Hi{ii})\(Hi{ii}'*y);
                end
                
            end
            
            for ii = 1:steps
                
                for jj = 1:N_nodes
                    
                    % Compute current weights
                    beta(idx{:}, jj) = Hinv{jj}*(Hi{jj}*beta(idx{:}, jj) + z - Hbeta_avg - t);
                    Hbeta_curr(idx{:}, jj) = Hi{jj}*beta(idx{:}, jj);
                    
                end
                
                % Compute new average
                % Run consensus
                [Hbeta_avg, ~] = ...
                    obj.run_consensus_serial(Hbeta_curr, obj.getParameter('consensus_max_steps'), obj.getParameter('consensus_thres'));
                
                % Update fusion variable
                z = (1/(N_nodes + rho))*(y + Hbeta_avg + t);
                
                % Update Lagrange coefficients
                t = t + Hbeta_avg - z;

                r_tmp(:) = 0;
                for jj = 1:N_nodes
                    r_tmp = r_tmp + Hbeta_curr(idx{:}, jj) - z;
                end
                obj.statistics.r_norm(ii) = norm(r_tmp);
                
                if(s.flags.debug && mod(ii, 10) == 0)
                    fprintf('\t\tADMM iteration #%i: primal residual = %.2f.\n', ...
                        ii, obj.statistics.r_norm(ii));
                end
                
            end
            
            if(steps > 0)
                % Save the weights
                for jj = 1:N_nodes
                    obj.local_models{jj}.outputWeights = beta(idx{:}, jj);
                end
            end
            
            obj.obj_locals{1} = obj;
        end
        
        function obj = executeBeforeTraining(obj, d)
            obj.local_models = cell(obj.topology.N, 1);
            for ii = 1:obj.topology.N
                obj.local_models{ii} = obj.model;
                d_local = obj.getLocalPart(d, ii);
                obj.local_models{ii} = obj.local_models{ii}.generateWeights(size(d_local.X.data, 2));
            end
        end
        
        function [labels, scores] = test_custom(obj, dataset)
            scores = zeros(size(dataset.X.data, 1), size(obj.local_models{1}.outputWeights, 2));
            
            for ii = 1:length(obj.local_models)
                Xts_local = obj.getLocalPart(dataset, ii);
                Xts_local = Xts_local.X.data;
                scores = scores + obj.local_models{ii}.computeHiddenMatrix(Xts_local)*obj.local_models{ii}.outputWeights;
                if(obj.getParameter('admm_max_steps') == 0)
                    break;
                end
            end
            
            labels = convert_scores(scores, dataset.task);
        end
        
        function b = checkForCompatibility(~, model)
            b = model.isOfClass('ExtremeLearningMachine');
        end
        
        function b = hasCustomTesting(obj)
            % The model is split over multiple nodes
            b = true;
        end
    end
    
    methods(Static)
        
        function info = getDescription()
            info = ['Model-distributed RVFL'];
        end
        
        function pNames = getParametersNames()
            pNames = {'C', 'consensus_max_steps', 'consensus_thres', 'admm_max_steps', 'admm_rho', 'admm_reltol', 'admm_abstol'};
        end
        
        function pInfo = getParametersDescription()
            pInfo = {'Regularization factor', 'Iterations of consensus', 'Threshold of consensus', ...
                'Iterations of ADMM', 'Penalty parameter of ADMM', 'Relative tolerance of ADMM', 'Absolute tolerance of ADMM'};
        end
        
        function pRange = getParametersRange()
            pRange = {'Positive real number, default is 1', 'Positive integer, default to 300', 'Positive real number, default to 0.001', ...
                'Positive integer, default to 300', 'Positive real number, default to 1', 'Positive real number, default to 0.001', 'Positive real number, default to 0.001'};
        end
    end
    
end

