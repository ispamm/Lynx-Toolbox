
% formatOutput - Print on screen the results of the simulation
%   This includes all the performance measures, and the training times. 
%   Primary performance measures and training times are printed in the form
%   of an ASCII table. The output of the other performance measures will 
%   depend on the OutputFormatters associated with them.
%
% See also: PerformanceMeasure, OutputFormatter

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function obj = formatOutput( obj )

    fprintf('--------------------------------------------------\n');
    fprintf('--- RESULTS --------------------------------------\n');
    fprintf('--------------------------------------------------\n');

    % Print the primary performances
    cprintf('-text', 'Primary performances:\n');
    FormatAsTable.displayOnConsole(cellfun(@(x)x{1}, obj.performanceMeasures, 'UniformOutput', false), ...
        obj.datasets.getNames(), obj.algorithms.getNames());
    
    % Print the training times
    cprintf('-text', 'Training times:\n');
    FormatAsTable.displayOnConsole(obj.trainingTimes, obj.datasets.getNames(), obj.algorithms.getNames());
    
    % Print all the secondary performance measures
    tasks = Tasks.getAllTasks();
    for ii = 1:length(tasks)
        
        % Select only the datasets of the i-th task
        d = obj.datasets;
        to_remove = false(length(d), 1);
        for jj = 1:length(d)
            o = obj.datasets.get(jj);
            if(o.task ~= tasks{ii}.getTaskId())
                to_remove(jj) = true;
            end
        end
        tmp_names = obj.datasets.getNames();
        tmp_names(to_remove) = [];
        tmp_perf = obj.performanceMeasures;
        tmp_perf(to_remove, :) = [];
        
        % Print the performance measure using the associated output
        % formatter
        if(~isempty(tmp_perf))
            for jj = 2:length(tmp_perf{1,1})
                cprintf('-text', '%s (for %s datasets):\n', tmp_perf{1,1}{jj}.getDescription(), tasks{ii}.getDescription());
                currentPerf = cellfun(@(x) x(jj), tmp_perf);
                f = currentPerf{1,1}.getDefaultOutputFormatter();
                f.displayOnConsole(currentPerf, tmp_names, obj.algorithms.getNames());
            end
        end
    end
    
    fprintf('\n');
end

