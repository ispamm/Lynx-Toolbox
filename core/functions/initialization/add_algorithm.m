
% ADD_ALGORITHM Add an algorithm to be tested.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function add_algorithm(algo_id, algo_name, algo_func, varargin)

    s = SimulationLogger.getInstance();
    
    currentAlgo.id = algo_id;
    currentAlgo.name = algo_name;
    
    try
        currentAlgo.model = algo_func(varargin);
    catch
        error('LearnToolbox:WrongArgument:algorithmnotfound', 'Cannot initialize algorithm %s, please verify the parameters', algo_name);
    end
    
    s.algorithms(end+1) = currentAlgo;

end

