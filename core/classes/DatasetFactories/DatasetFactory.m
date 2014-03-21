classdef DatasetFactory
    % DATASETFACTORY Base class for creating datasets related to a
    % given task. This simply calls the corresponding derived
    % DatasetFactory object. If the task is R or BC or MC,
    % DatasetFactoryBasic is called, otherwise DatasetFactoryxxx, where xxx
    % is the id of the task. This has only a single static method create.
    %
    % DatasetFactory methods:
    %
    %   CREATE(TASK, DID, DNAME, FNAME, SUBSAMPLE, VARARGIN) creates an 
    %   object of type dataset. Name and id are given by DID and DNAME
    %   respectively. Data is loaded from the file FNAME, using the derived
    %   DatasetFactory class identified by TASK. SUBSAMPLE and VARARGIN are
    %   passed to such class.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    methods(Static)
        function datasets = create(task, dID, data_name, fileName, subsample, varargin)
           if(strcmp(task, 'R') || strcmp(task, 'BC') || strcmp(task, 'MC'))
               datasets = DatasetFactoryBasic.create(task, dID, data_name, fileName, subsample, varargin{:});
           else
               dFactory = eval(strcat('DatasetFactory', task));
               datasets = dFactory.create(task, dID, data_name, fileName, subsample, varargin{:});
           end
        end
    end
    
end

