classdef ApplyPca < Preprocessor
    % APPLYPCA Applies a Principal Component Analysis to the dataset.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    methods
      
        function obj = ApplyPca(varargin)
            obj = obj@Preprocessor(varargin);
        end
        
        function initParameters(obj, p)
            p.addParamValue('varianceToPreserve', 0.95);
        end
        
        function dataset = process( obj, dataset )
            dataset.X = processpca(dataset.X', 'maxfrac' , 1 - obj.params.varianceToPreserve);
            dataset.X = dataset.X';
        end
        
    end
    
    methods(Static)

        function info = getInfo()
            info = 'Apply a Principal Component Analysis to the dataset';
        end
        
        function pNames = getParametersNames()
            pNames = {'varianceToPreserve'}; 
        end
        
        function pInfo = getParametersInfo()
            pInfo = {'Percentage of variance to keep into the transformed dataset'};
        end
        
        function pRange = getParametersRange()
            pRange = {'[0,1], default is 0.95'};
        end   
        
    end

end

