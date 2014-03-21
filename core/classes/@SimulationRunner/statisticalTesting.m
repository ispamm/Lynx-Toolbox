
% STATISTICALTESTING Execute the statistical testing if there are enough
% algorithms and datasets, and if there are no inconsistencies

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function obj = statisticalTesting( obj )

if(length(obj.algorithms) > 1 && length(obj.datasets) > 1 && obj.fullCompatibility)
    
    fprintf('--------------------------------------------------\n');
    fprintf('--- STATISTICAL ANALYSIS -------------------------\n');
    fprintf('--------------------------------------------------\n');
    
    if(length(obj.algorithms) == 2)
        compare_two_classifiers(obj.getAlgorithmsNames(), mean(obj.computedError, 3));
    else
        compare_N_classifiers(obj.getDatasetsNames(), obj.getAlgorithmsNames(), mean(obj.computedError, 3));
    end
    
end

end

