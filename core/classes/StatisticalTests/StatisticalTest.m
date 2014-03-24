classdef StatisticalTest
    
    %STATISTICALTEST This represents an object for perfoming a statistical
    %testing. Any derived class A must implement two static methods:
    %
    %   [B, RES] = A.CHECK_COMPATIBILITY(ALGORITHMS, DATASETS) returns a
    %   boolean B indicating whether the statistical test is consistent
    %   with the choice of algorithms and datasets. In case B is false, RES
    %   is a string explaining the inconsistency.
    %
    %   PERFORM_TEST(DATASETS, ALGORITHMS, ERRRORS) performs the 
    %   statistical testing using the errors in the matrix ERRORS. This is 
    %   an MxN matrix, where the (i,j) elements if the averaged error of 
    %   the i-th algorithm on the m-th dataset. ALGORITHMS and DATASETS are
    %   two cell arrays of strings with the names of the algorithms and the
    %   datasets respectively.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it

    methods(Abstract,Static)
        [b, res] = check_compatibility(algorithms, datasets);
        perform_test(datasets_names, algorithms_names, errors);
    end
    
end

