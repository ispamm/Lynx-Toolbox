% EmbedTimeseriesFactory - Embed the timeseries of a prediction task
%   This DatasetFactory embeds the time series in the original dataset into
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
        
        function datasets = process(obj, d)
            
            N = length(d.X.data);
            N_embedded = N - obj.embeddingDimension - obj.timeHorizon + 1;
            
            X_embedded = zeros(N_embedded, obj.embeddingDimension);
            Y = zeros(N_embedded, 1);
            
            for i=1:N_embedded
                X_embedded(i,:) = d.X.data(i:i + obj.embeddingDimension-1);
                Y(i) = d.X.data(i + obj.embeddingDimension + obj.timeHorizon - 1);
            end
            
            datasets = {Dataset(RealMatrix(X_embedded), RealLabelsVector(Y), Tasks.R)};
            fprintf('Embedded dataset %s, %i samples extracted\n', data_name, size(X_embedded, 1));

        end
    end
    
end

