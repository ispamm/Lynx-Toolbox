
% FINALIZESIMULATION Finalize the simulation, i.e. close the open logs,
% close the matlab pool (if open) and delete the temporary files

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function obj = finalizeSimulation( obj )

% Finalizes the simulation

diary('off');

% Close the MATLAB pool if open
if(matlabpool('size') > 0)
    matlabpool('close');
end

% Delete temporary files
warning('off', 'MATLAB:DELETE:Permission')
delete('./tmp/*');
warning('on', 'MATLAB:DELETE:Permission')

delete('*.aux');
delete('*.log');

end

