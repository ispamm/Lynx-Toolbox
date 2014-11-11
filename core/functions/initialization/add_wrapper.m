
% add_wrapper - Add a wrapper to the simulation

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function add_wrapper(algo_id, wrapper, varargin)

    s = Simulation.getInstance();
    
    ids = s.algorithms.findByIdWithRegexp(algo_id);
    
    for i=1:length(ids)
        algo = s.algorithms.get(ids(i));

        try
            algoWrapped = ...
                wrapper(algo, varargin{:});
        catch err
            error('Lynx:WrongArgument:Wrapper', 'Cannot initialize wrapper for model %s\nError returned: %s', algo_id, err.message);
        end
    
        if(~algoWrapped.checkForCompatibility(algo))
            error('Lynx:Runtime:Wrapper', 'The wrapper %s cannot be applied to model %s', class(algoWrapped), algo_id);
        end

        s.algorithms = s.algorithms.set(ids(i), algoWrapped);
    end

end

