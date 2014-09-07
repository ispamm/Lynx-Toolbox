% BasicTask - A possible learning task
%   A task is a basic learning task, e.g. regression. This class
%   provides utility methods  checking the consistency of datasets, and 
%   keeping tracks of the folders where they are stored. Note that this 
%   implements the Singleton pattern.
%
% BasicTask properties:
%
%   folders - Cell array of folders where the datasets are stored
%   performance_measure - Current primary performance measure
%
% BasicTask methods:
%
%   getPerformanceMeasure - Return the current PerformanceMeasure
%   object for this task
%
%   getDescription - Return a string describing the task
%
%   getTaskId - Return the unique id of this learning task
%
%   checkForConsistency - Check that a given dataset is consistent
%   with this task
%
%   loadDataset - Search for a given .mat file inside the specified
%   folders
%
%   addFolder - Add a new folder
%
% See also: SingletonClass, PerformanceMeasure, DatasetFactory

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef BasicTask < SingletonClass
    
    properties
        % Cell array of folders
        folders;
        % Performance measure
        performance_measure;
    end
    
    methods(Abstract)
        
        % Return a string describing the task
        s = getDescription(obj);
        
        % Return the unique ID of this task
        id = getTaskId(obj);
        
        % Check for consistency
        obj = checkForConsistency(obj, d);
        
        % Get default output type
        datatype = getDataType(obj, y);
    end
    
    methods(Access=protected)
        function obj = BasicTask()
            obj = obj@SingletonClass();
            obj.folders = {};
        end
    end
    
    methods
        
        function setPerformanceMeasure(obj, p)
            % Change the performance measure for this task
            obj.performance_measure = p;
        end

        function p = getPerformanceMeasure(obj)
            % Return the default performance measure for this task
            p = obj.performance_measure;
        end
        
        function d = loadDataset(obj, dataset_file)
            % Search a given .mat file inside the associated folders, and
            % check its consistency with respect to the task
            filename = strcat(dataset_file, '.mat');
            
            ii = 1;
            found = false;
            d = [];
            
            % Search the dataset in each subfolder
            while ii <= length(obj.folders) && ~found
                fold = strcat(obj.folders{ii} , '/');
                if(exist(strcat(fold, filename), 'file'))
                    
                    d = load(strcat(fold, filename));
                    found = true;
                    
                end
                ii = ii + 1;
                
            end
            
        end
        
        function obj = addFolder(obj, folder)
            % Add a folder to the task
            obj.folders{end + 1} = fullfile(XmlConfiguration.getRoot(), folder);
        end
        
        function flist = getAllFiles(obj)
            % Get all files for this task
            flist = {};
            for i = 1:length(obj.folders)
                f = getAllFiles(obj.folders{i});
                flist = {flist{:} f{:}};
            end
        end
        
    end
    
end

