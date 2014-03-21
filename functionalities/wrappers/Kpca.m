classdef Kpca < Wrapper
    % KPCA % A wrapper for applying KPCA to data before processing. Note 
    % that if you want to apply KPCA to a single dataset, you can use the
    % related Kpca Preprocessor.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    properties
        eigenVectors;
        Xtr;
    end
    
    methods
        
        function obj = Kpca(wrappedAlgo, varargin)
            obj = obj@Wrapper(wrappedAlgo, varargin);
        end
        
        function initParameters(~, p)
            p.addParamValue('subsample', 1);
            p.addParamValue('pcToKeep', 100);
            p.addParamValue('kernel_type', 'gauss');
            p.addParamValue('kernel_para', 1);
        end
        
        function obj = train(obj, Xtr, Ytr)
            N = floor(obj.trainingParams.subsample*size(Xtr,1));
            obj.Xtr = Xtr(1:N,:);
            
            if(obj.trainingParams.pcToKeep > size(obj.Xtr,1))
                obj.trainingParams.pcToKeep = size(obj.Xtr,1);
            end
            
            n = size(Xtr,1);
            % Adapted from the KM toolbox
            K = km_kernel(Xtr, Xtr, obj.trainingParams.kernel_type,obj.trainingParams.kernel_para);
            [E, V] = eig(K);
            v = diag(V);	% eigenvalues
            [v,ind] = sort(v,'descend');
            v = v(1:obj.trainingParams.pcToKeep);
            E = E(:,ind(1:obj.trainingParams.pcToKeep));	% principal components
            for i=1:obj.trainingParams.pcToKeep
                E(:,i) = E(:,i)/sqrt(n*v(i));	% normalization
            end
            Xtr = (E'*K)';
            obj.eigenVectors = E;
           
            obj.wrappedAlgo = obj.wrappedAlgo.setTask(obj.getTask());
            obj.wrappedAlgo = obj.wrappedAlgo.train(Xtr, Ytr);
        end
    
        function [labels, scores] = test(obj, Xts)
            if(strcmp(obj.trainingParams.kernel_type, 'custom'))
                K = Xts;
            else
                K = km_kernel(obj.Xtr, Xts, obj.trainingParams.kernel_type, obj.trainingParams.kernel_para);
            end
            
            Xp = (obj.eigenVectors'*K)';
            [labels, scores] = obj.wrappedAlgo.test(Xp);
        end
    end
    
    methods(Static)
        function info = getInfo()
            info = 'Applies a KPCA to the data before running the algorithm';
        end
        
        function pNames = getParametersNames()
            pNames = {'pcToKeep', 'kernel_type', 'kernel_para'}; 
        end
        
        function pInfo = getParametersInfo()
            pInfo = {'Number of principal components to keep', 'Kernel function', 'Kernel parameters'};
        end
        
        function pRange = getParametersRange()
            pRange = {'Positive integer, default 100', 'String, see help kernel_matrix, default rbf', ...
                'Vector of real numbers, see help kernel_matrix, default 1'};
        end
    end
    
end