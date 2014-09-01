
% add_feature - Add additional feature to the simulation

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function add_feature( f )

s = Simulation.getInstance();
s.additionalFeatures{end + 1} = f;

end

