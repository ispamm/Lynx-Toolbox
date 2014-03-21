
% ADD_WRAPPER Add a wrapper to the simulation

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function add_wrapper(algo_id, wrapper, varargin)

    s = SimulationLogger.getInstance();
    algo_index = s.findAlgorithmById(algo_id);

    algo = s.algorithms(algo_index);
    algo.model = ...
        wrapper(algo.model, varargin{:});
    s.algorithms(algo_index) = algo;

end

