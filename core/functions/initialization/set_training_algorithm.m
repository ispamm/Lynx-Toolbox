
% set_training_algorithm - Set the training algorithm of a model

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function set_training_algorithm(algo_id, algo_func, varargin)

    s = Simulation.getInstance();

    currentAlgo = s.algorithms.getById(algo_id).model;
    
    try
        currentAlgo = algo_func(currentAlgo, varargin{:});
    catch err
        error('Lynx:WrongArgument:AlgorithmNotFound', 'Cannot initialize algorithm %s\nError returned: %s', algo_id, err.message);
    end
    
    s.algorithms = s.algorithms.set(s.algorithms.findById(algo_id), currentAlgo);

end

