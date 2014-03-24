classdef WilcoxonTest < StatisticalTest
    %WILCOXONTEST Compares two LearningAlgorithm depending on their
    % performance using a Wilcoxon Signed-ranks test. For informations on 
    % the test, see: [1] J. Demšar, “Statistical comparisons of classifiers
    % over multiple data sets,” J. Mach. Learn. Res., vol. 7, pp. 1–30, 
    % 2006. The confidence value is set at alpha = 0.05.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    methods(Static)
        function [b, res] = check_compatibility(algorithms, datasets)
            b = (length(algorithms) == 2) && (length(datasets) > 1);
            if(~b)
                res = 'The Wilcoxon signed-rank test requires exactly two algorithms and at least two datasets';
            else
                res = '';
            end
        end
        
        function perform_test(~, names, errors)
            N_datasets = size(errors, 2);
            [p, h] = ranksum(errors(1,:), errors(2,:));

            equal_ranks = sum(errors(1,:) == errors(2,:));

            R_plus = sum(errors(1,:) < errors(2,:));
            R_minus = (N_datasets - equal_ranks - R_plus);

            fprintf('On %i datasets, %s wins %i times, ties %i times and loses %i times\n', N_datasets, names{1}, R_plus, equal_ranks, R_minus);

            if(h)
                fprintf('There is significant difference at alpha = 0.05 using the Wilcoxon signed-rank test (z = %f)\n', p);
            else
                fprintf('No significant difference has been found at alpha = 0.05 using the Wilcoxon signed-rank test (z = %f)\n', p);
            end
        end
    
    end
    
end

