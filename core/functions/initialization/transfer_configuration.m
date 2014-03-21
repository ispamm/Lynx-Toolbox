
% TRANSFER_CONFIGURATION Changes the configuration of an algorithm
% by loading the specific fields from another algorithm.
%
%   TRANSFER_CONFIGURATION(DEST, SOURCE, PARAMS) When executing
%   algorithm DEST, load the configuration parameters
%   identified in the cell array PARAMS from the algorithm SOURCE.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function transfer_configuration(dest_id, source_id, params, params_dest)

    if(nargin < 4)
        params_dest = params;
    end
    
    if(isempty(params))
        error('Empty cell array of parameters names');
    end
    
    add_wrapper(dest_id, @LoadConfiguration, './tmp/', source_id, params, params_dest);
    add_wrapper(source_id, @SaveConfiguration, source_id);

end

