
% add_performance - Add a performance measure to a given task.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function add_performance( task, p, primary )

if(nargin < 3)
    primary = false;
end

t = Tasks.getById(task);

if(~p.isCompatible(task))
    error('Lynx:Runtime:PerformanceNotCompatible', 'Performance measure %s is not compatible with task %s', class(p), t.getDescription());
end

if(primary)
    if(~p.isComparable)
        error('Lynx:Runtime:PerformanceNotComparable', 'Performance measure %s cannot be set as primary', class(p));
    end
    t.setPerformanceMeasure(p);
else
    pe = PerformanceEvaluator.getInstance();
    pe = pe.addSecondaryPerformanceMeasure(task, p);
end

end

