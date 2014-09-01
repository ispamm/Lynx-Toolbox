
% set_runs - Set the number of runs of the simulation

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function set_runs( n )

s = Simulation.getInstance();
s.nRuns = n;

end

