% EmbedTimeseriesFactory - Embed the timeseries of a prediction task
%   This DatasetFactory embeds the time series in the original file into
%   a R^d dimensional space. This effectively transform the original task
%   into a regression task.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef EmbedTimeseriesFactory < DatasetFactory
    
    properties
        % Embedding dimensionality for the timeseries
        embeddingDimension;
        % Time horizon for prediction
        timeHorizon;
    end
    
    methods
        
        function obj = EmbedTimeseriesFactory(ed, th)
            assert(isnatural(ed, false), 'Lynx:Validation:InvalidInput', 'Embedding dimension for a time series must be a natural number');
            assert(isnatural(th, false), 'Lynx:Validation:InvalidInput', 'Time horizon for a time series must be a natural number');
            obj.embeddingDimension = ed;
            obj.timeHorizon = th;
        end
        
        function datasets = create(obj, task, data_id, data_name, o)
            
            N = length(o.X);
            N_embedded = N - obj.embeddingDimension - obj.timeHorizon + 1;
            
            X_embedded = zeros(N_embedded, obj.embeddingDimension);
            Y = zeros(N_embedded, 1);
            
            for i=1:N_embedded
                X_embedded(i,:) = o.X(i:i + obj.embeddingDimension-1);
                Y(i) = o.X(i + obj.embeddingDimension + obj.timeHorizon - 1);
            end
            
            fprintf('Embedded dataset %s, %i samples extracted\n', data_name, size(X_embedded, 1));
            datasets = {Dataset(data_id, data_name, Tasks.R, X_embedded, Y)};
        end
    end
    
end

