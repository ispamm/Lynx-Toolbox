
% add_model - Add a model to be tested.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function add_model(algo_id, algo_name, algo_func, varargin)

    s = Simulation.getInstance();

    try
        currentAlgo = algo_func(algo_id, algo_name, varargin{:});
        currentAlgo = currentAlgo.getDefaultTrainingAlgorithm();
    catch
        error('Lynx:WrongArgument:AlgorithmNotFound', 'Cannot initialize algorithm %s, please verify the parameters', algo_name);
    end
    
    s.algorithms = s.algorithms.addElement(currentAlgo);

end

