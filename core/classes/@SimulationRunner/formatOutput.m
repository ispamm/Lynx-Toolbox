
% FORMATOUTPUT Print on screen the results of the simulation, i.e. testing
% errors and training times (in both cases, mean and standard variation)

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function obj = formatOutput( obj )

    fprintf('--------------------------------------------------\n');
    fprintf('--- RESULTS --------------------------------------\n');
    fprintf('--------------------------------------------------\n');

    algorithms_names = obj.getAlgorithmsNames();
    datasets_names = obj.getDatasetsNames();
    
    disp('Average error:');
    disptable(mean(obj.computedError,3)', algorithms_names, datasets_names);

    if(any(obj.computedError_std) ~= 0)
        
        disp('Std error (computed over the runs):');
        disptable(mean(obj.computedError_std, 3)', algorithms_names, datasets_names);
        
    else
    
        disp('Std error (averaged over the runs):');
        disptable(std(obj.computedError, 1, 3)', algorithms_names, datasets_names);
        
    end

    disp('Average training time:');
    disptable(mean(obj.trainingTime,3)', algorithms_names, datasets_names);

    disp('Std training time (averaged over the runs):');
    disptable(mean(obj.trainingTime_std, 3)', algorithms_names, datasets_names);


end

