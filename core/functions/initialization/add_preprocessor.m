
% ADD_PREPROCESSOR Add a preprocessor to the simulation

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function add_preprocessor(data_id, preprocessor, varargin)

    s = SimulationLogger.getInstance();
    ids = s.findDatasetByIdWithRegexp(data_id);
    
    for i=1:length(ids)
    
        obj = preprocessor(varargin);
        s.datasets{ids(i)} = obj.process(s.datasets{ids(i)});
    
    end
       
end

