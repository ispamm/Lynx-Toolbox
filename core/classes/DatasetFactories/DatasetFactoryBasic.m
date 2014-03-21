classdef DatasetFactoryBasic < DatasetFactory
    % DATASETFACTORYBASIC A class for creating datasets of basic type.
    % Basically, this loads the file and eventually subsample the X and Y
    % matrices.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    methods(Static)
        function datasets = create(task, data_id, data_name, fileName, subsample, varargin)
          
          load(fileName);
            
          % Eventually subsample the input
          if(subsample < 1)
              cv = cvpartition(size(X,1), 'Holdout', subsample);
              X = X(test(cv),:);
              Y = Y(test(cv),:);
          end
         
          datasets = {Dataset(data_id, data_name, Tasks.(task), X, Y)};
        
        end
    end
    
end

