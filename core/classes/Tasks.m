% Tasks - A list of all the possible supervised learning tasks implemented in the toolbox
%
% This provides two utility methods:
%
%   getById - Return the BasicTask instance associated to a given ID
%   getAllTasks - Return all BasicTask instances

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef Tasks < uint32
    
    enumeration
        R   (1),  % Regression
        BC  (2), % Binary Classification
        MC  (3), % Multiclass Classification
        ML  (4)  % Multi-label
    end
    
    methods
        function ind = subsindex(A)
            ind = uint32(A) - 1;
        end
    end
    
    methods(Static)
        function t = getById(tID)
            tasks = class_filter(fullfile(XmlConfiguration.getRoot(), 'core/classes/Tasks/'), 'BasicTask');
            for ii = 1:length(tasks)
                id = eval([tasks(ii).Classname, '.getInstance().getTaskId()']);
                if(tID ==  id)
                    t = eval([tasks(ii).Classname, '.getInstance()']);
                end
            end
        end
        
        function tasks = getAllTasks()
            tid = class_filter(fullfile(XmlConfiguration.getRoot(), 'core/classes/Tasks'), 'BasicTask');
            tasks = cell(length(tid), 1);
            for ii = 1:length(tid)
                tasks{ii} = eval([tid(ii).Classname, '.getInstance()']);
            end
        end
    end
    
    
end