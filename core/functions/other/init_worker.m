
% SAVE_PERFORMANCE_FUNCTION A dummy function that saves the configuration
% in the current worker

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function init_worker( log )

    currentLog = SimulationLogger.getInstance();
    currentLog.copyConfiguration(log);

end

