
% SET_FLAG Set a flag to true in the SimulationLogger

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function set_flag( f )

    s = SimulationLogger.getInstance();
    s.flags.(f) = true;

end

