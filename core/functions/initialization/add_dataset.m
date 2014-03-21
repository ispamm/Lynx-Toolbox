
% ADD_DATASET  Add a dataset to be tested, with given id, name, and 
% filename

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function add_dataset(data_id, data_name, file, subsample, varargin)

    % Subsample is used to load only a given percentage of a dataset
    if(nargin < 4)
        subsample = 1;
    end

    s = SimulationLogger.getInstance();
    
    filename = strcat(file, '.mat');
    [~, names] = enumeration('Tasks');
    
    i = 1;
    found = false;
    
    % Search the dataset in each subfolder
    while i<=length(names) && ~found
       fold = strcat('datasets/', names{i}, '/');
       if(exist(strcat(fold, filename), 'file'))
          
          task = names{i};
          
          s.datasets = [s.datasets; DatasetFactory.create(task, data_id, data_name, strcat(fold, filename), subsample, varargin{:})];
          
          found = true;
          
       end
       i = i+1;
    end
    
    if(~found)
        error('LearnTool:Logic:DatasetNotFound', ['Dataset ', data_name, ' not found.']);
    end

end

