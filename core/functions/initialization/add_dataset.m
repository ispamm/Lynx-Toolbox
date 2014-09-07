
% add_dataset - Add a dataset to be tested, with given id, name, and filename

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function add_dataset(data_id, data_name, file, f)

    s = Simulation.getInstance();
    
    tasks = Tasks.getAllTasks();
    
    ii = 1;
    found = false;
    
    % Search the dataset in each task
    while ii <= length(tasks) && ~found
        d = tasks{ii}.loadDataset(file);
        if(~isempty(d))
            found = true;
            d = d.dataset;
            d = d.setIdAndName(data_id, data_name);
            if(nargin == 4)
                d = d.process(f);
            else
                d = d.process();
            end
            for jj = 1:length(d)
                s.datasets = s.datasets.addElement(d{jj});
            end
        end
        ii = ii + 1;
    end
    
    if(~found)
        error('Lynx:Logic:DatasetNotFound', ['Dataset ', data_name, ' not found.']);
    end

end

