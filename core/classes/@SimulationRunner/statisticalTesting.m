
% STATISTICALTESTING Execute the statistical testing if there are no 
% inconsistencies

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function obj = statisticalTesting( obj )

if(obj.fullCompatibility)
    
    fprintf('--------------------------------------------------\n');
    fprintf('--- STATISTICAL ANALYSIS -------------------------\n');
    fprintf('--------------------------------------------------\n');
    
    obj.statistical_test.perform_test(obj.getDatasetsNames(), obj.getAlgorithmsNames(), mean(obj.computedError, 3));

    fprintf('\n');
    
end

end

