
% SET_PERFORMANCE Set the current performance measure for a given task
%
%   SET_PERFORMANCE(TASK, PERF) Change the performance measure used on task
%   of type TASK to measure PERF.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function set_performance( task, perf )

    s = SimulationLogger.getInstance();
    s.performanceMeasures(char(task)) = perf;

end