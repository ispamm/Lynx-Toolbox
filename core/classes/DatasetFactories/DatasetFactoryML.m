classdef DatasetFactoryML < DatasetFactory
    % DATASETFACTORYPR Creates datasets for a multilabel task. If the
    % dataset has M distinct labels, this creates M binary classification
    % tasks.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    methods(Static)
        function datasets = create(task, data_id, data_name, fileName, subsample, varargin)
           
          load(fileName);
            
          currentDataset = DatasetFactoryBasic.create(task, data_id, data_name, fileName, subsample);
          currentDataset = currentDataset{1};
          datasets = cell(0,0);
          
          nLabels = size(currentDataset.Y, 2);
              newX = currentDataset.X;
              newtask = Tasks.BC;
              
              for j=1:nLabels
                  newY = currentDataset.Y(:, j);
                  newname = sprintf('%s (%s)', data_name, labels_info{j});
                  newID = sprintf('%s-%d', data_id, j);
                  datasets{end+1} = Dataset(newID, newname, newtask, newX, newY);
              end
              
              fprintf('Extracted %i different binary classification datasets from original dataset %s\n', nLabels, data_name);
          
        end
    end
    
end

