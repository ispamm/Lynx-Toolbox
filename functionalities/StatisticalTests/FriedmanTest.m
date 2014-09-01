% FriedmanTest - Friedman statistical test
%   Compare the performance of several classifiers using a corrected
%   Friedman test. If the test reveals significant differences, perform
%   a set of post-hoc Nemenyi test between each pair of algorithms. For 
%   informations on the tests, see: 
%       [1] J. Demšar, “Statistical comparisons of classifiers over 
%       multiple data sets,” J. Mach. Learn. Res., vol. 7, pp. 1–30, 2006. 
%   The confidence value is set at alpha = 0.05;

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef FriedmanTest < StatisticalTest
    
    methods(Static)
        function [b, res] = check_compatibility(algorithms, datasets)
            b = (length(algorithms) > 2) && (length(datasets) > 1);
            if(~b)
                res = 'The corrected Friedman test requires at least three algorithms and at least two datasets';
            else
                res = '';
            end
        end
        
        function perform_test(data_names, algo_names, errors)
            [N_algo, N_data] = size(errors);
            ranks = zeros(N_algo, N_data);
            
            for i = 1:N_data
                ranks(:, i) = tiedrank(errors(:, i));
            end
            
            fprintf('\n');
            fprintf('Table of ranks:\n');
            disptable(ranks', algo_names, data_names);
            
            R = mean(ranks, 2);
            
            fprintf('\n');
            fprintf('Mean ranks:\n');
            disptable(R', algo_names);
            
            chi_f_squared = ((12*N_data)/(N_algo*(N_algo+1)))*(sum(R.^2) - ((N_algo*((N_algo+1)^2))/4));
            Ff = ((N_data-1)*chi_f_squared)/((N_data*(N_algo-1))-chi_f_squared);
            
            tres = finv(0.95,N_algo-1,(N_algo-1)*(N_data-1));
            
            if(Ff > tres)
                fprintf('There is significant difference at alpha = 0.05 using the corrected Friedman test (Ff = %f > %f)\n', Ff, tres);
                
                if(N_algo > 10)
                    fprintf('At this moment, no ad-hoc tests are possible with more than 10 algorithms.');
                else
                    q = [0 1.960 2.343 2.569 2.728 2.850 2.949 3.031 3.102 3.164];
                    CD = q(N_algo)*sqrt((N_algo*(N_algo+1))/(6*N_data));
                    fprintf('\n');
                    fprintf('The following pairs have significant differences according to the Nemenyi test at alpha = 0.05 (CD = %f):\n', CD);
                    for i = 1:N_algo
                        for j = (i+1):N_algo
                            rank_diff = R(j) - R(i);
                            if(abs(rank_diff) > CD)
                                fprintf('\t%s and %s [rank difference = %f]\n', algo_names{i}, algo_names{j}, rank_diff );
                            end
                        end
                    end
                end
                
            else
                fprintf('No significant difference has been found at alpha = 0.05 using the corrected Friedman test (Ff = %f < %f)\n', Ff, tres);
            end
        end
        
        function s = getDescription()
            s = 'Corrected Friedman test';
        end
        
    end
    
end

