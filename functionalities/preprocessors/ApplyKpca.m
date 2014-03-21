classdef ApplyKpca < Preprocessor
    % APPLYKPCA Applies a Kernel Principal Component Analysis to the
    % dataset.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    methods
      
        function obj = ApplyKpca(varargin)
            obj = obj@Preprocessor(varargin);
        end
        
        function initParameters(obj, p)
            p.addParamValue('outputDimensionality', 10);
            p.addParamValue('kernel_type', 'gauss');
            p.addParamValue('kernel_para', 1);
        end
        
        function dataset = process( obj, dataset )
            n = size(dataset.X,1);
            % Adapted from the KM toolbox
            K = km_kernel(dataset.X,dataset.X, obj.params.kernel_type,obj.params.kernel_para);
            [E,V] = eig(K);
            v = diag(V);	% eigenvalues
            [v,ind] = sort(v,'descend');
            v = v(1:obj.params.outputDimensionality);
            E = E(:,ind(1:obj.params.outputDimensionality));	% principal components
            for i=1:obj.params.outputDimensionality
                E(:,i) = E(:,i)/sqrt(n*v(i));	% normalization
            end
            dataset.X = (E'*K)';
        end
        
    end
    
    methods(Static)

        function info = getInfo()
            info = 'Apply a Kernel Principal Component Analysis to the dataset';
        end
        
        function pNames = getParametersNames()
            pNames = {'outputDimensionality', 'kernel_type', 'kernel_para'}; 
        end
        
        function pInfo = getParametersInfo()
            pInfo = {'Number of principal components to keep', 'Kernel function', 'Kernel parameters'};
        end
        
        function pRange = getParametersRange()
            pRange = {'Positive integer, default is 10', 'String in {gauss, gauss-diag, poly, linear or custom}, default is gauss', ...
                'Vector of real numbers, default is 1'};
        end   
        
    end

end

