classdef DatasetFactoryPR < DatasetFactory
    % DATASETFACTORYPR Creates datasets for a prediction task. Timeseries is
    % converted to a regression task by d-dimensional embedding, with d
    % specificed by the user.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    methods(Static)
        function datasets = create(task, data_id, data_name, fileName, subsample, varargin)
           
          load(fileName);
          Y = X;
          
          if(subsample < 1)
            splitPoint = floor(subsample*length(X));
            X = X(1:splitPoint);
            Y = Y(1:splitPoint);
          end

          % Embed the timeseries
          assert(~isempty(varargin), 'LearnToolbox:Validation:MissingArgument', 'An embedding factor should be provided for a prediction task');
          fprintf('Embedding timeseries %s...\n', data_name);
          p = EmbedTimeseries(varargin);
          datasets = {p.process(Dataset(data_id, data_name, Tasks.(task), X, Y))}; 
        
        end
    end
    
end

