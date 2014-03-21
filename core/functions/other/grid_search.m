
% GRID_SEARCH Performs a grid search for the optimal parameters.
% 
%   [P E] = GRID_SEARCH(ALGO, DATASET, PARTITION, NAMES, COMBINATIONS)
%   Execute algorithm ALGO on dataset DATASET, by setting in turn the
%   parameters NAMES to all the values contained in the matrix
%   COMBINATIONS. Returns the best combination P and the minimum validation
%   error E. PARTITION is the cvpartition to be used for computing the
%   error.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function [ bestParam, bestError ] = grid_search( algo, dataset, parameterNames, params_tosearch )

bestError = Inf;

call = strcat('combvec(', mat2str(params_tosearch{1}));

for i=2:length(params_tosearch)
   call = strcat(call, ', ', mat2str(params_tosearch{i})); 
end

call = strcat(call, ');'); 
combinations = eval(call);

for zz=1:size(combinations, 2)

    paramsToTest = combinations(:,zz);

    for i=1:length(parameterNames)
       algo = algo.setTrainingParam(parameterNames{i}, paramsToTest(i));
    end
    
    [currentError, ~] = eval_algo( algo, dataset );
    
    if(currentError < bestError)
        bestParam = combinations(:, zz);
        bestError = currentError;
    end
    
end

end