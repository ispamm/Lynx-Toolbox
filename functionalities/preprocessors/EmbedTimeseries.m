classdef EmbedTimeseries < Preprocessor
    % EMBEDTIMESERIES Embed a timeseries (this should be used only by the
    % toolbox).
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    methods
        
        function obj = EmbedTimeseries(varargin)
            obj = obj@Preprocessor(varargin);
        end
        
        function initParameters(obj, p)
            p.addParamValue('embeddingFactor', 6);
        end
        
        function data = process( obj, data )
            N = length(data.X);
            N_embedded = N - obj.params.embeddingFactor;
            
            X_embedded = zeros(N_embedded, obj.params.embeddingFactor);
            Y = zeros(N_embedded, 1);
            
            for i=1:N_embedded
                X_embedded(i,:) = data.X(i:i+ obj.params.embeddingFactor-1);
                Y(i) = data.X(i+obj.params.embeddingFactor);
            end
            
            data.X = X_embedded;
            data.Y = Y;
            data.task = Tasks.R;
        end
        
    end
    
    methods(Static)
        
        function info = getInfo()
            info = 'Embed the timeseries into an n-dimensional space, transforming the task into a regression one';
        end
        
        function pNames = getParametersNames()
            pNames = {'embeddingFactor'};
        end
        
        function pInfo = getParametersInfo()
            pInfo = {'Dimensionality of the resulting embedding vector'};
        end
        
        function pRange = getParametersRange()
            pRange = {'Positive integer, default is 6'};
        end
        
    end
    
    
end

