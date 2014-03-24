classdef NoStatisticalTest < StatisticalTest
    %NOSTATISTICALTEST A dummy class representing the action of not
    %performing a statistical testing.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    methods(Static)
        function [b, res] = check_compatibility(~, ~)
            b = true;
            res = '';
        end
        
        function perform_test(~, ~, ~)
            fprintf('No statistical testing was requested.\n');
        end
    
    end
    
end

