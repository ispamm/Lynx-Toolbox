
% add_preprocessor - Add a preprocessor to the simulation

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function add_preprocessor(data_id, preprocessor, varargin)

    s = Simulation.getInstance();
    ids = s.datasets.findByIdWithRegexp(data_id);
    
    for i=1:length(ids)
    
        o = preprocessor(varargin{:});
        s.datasets.set(ids(i), ...
            o.process(s.datasets.get(ids(i))));
    
    end
       
end

