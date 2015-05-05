
% finalizeSimulation - Execute the steps needed to finalize the simulation
%   Two steps are performed: closing the matlabpool (if open), and deleting
%   the temporary files. This is also executed if an error occurs during th
%   the simulation.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function obj = finalizeSimulation( obj )

% Close the MATLAB pool if open
ParallelHelper.close_pool();

% Delete temporary files
warning('off', 'MATLAB:DELETE:Permission');
delete(fullfile(XmlConfiguration.getRoot(), 'tmp/*'));
warning('on', 'MATLAB:DELETE:Permission');

end

