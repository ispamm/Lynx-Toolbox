% CheckSignificance - Perform a statistical test on the results
%   This additional feature perform a statistical testing on the
%   results of the simulation, taking into consideration only the
%   primary performances. The statistical test can be any object of
%   class StatisticalTest.
%
% See also: StatisticalTest

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef CheckSignificance < AdditionalFeature
    
    properties
        test; % An object of class StatisticalTest
    end
    
    methods
        function obj = CheckSignificance(t)
            obj.test = t;
        end
        
        function executeBeforeInitialization(obj)
            % We check that algorithms and datasets are compatible with the
            % statistical test
            s = Simulation.getInstance();
            [b,s] = obj.test.check_compatibility(s.algorithms, s.datasets);
            if(~b)
                error('Lynx:Runtime:StatisticalTest', s);
            end
        end
        
        function executeAfterInitialization(obj)
            % For running the statistical test, we require that no
            % inconsistencies are found.
            s = Simulation.getInstance();
            if(~s.fullCompatibility)
                error('Lynx:Runtime:StatisticalTest', 'The statistical test cannot run because there are incompatibilities between algorithms and datasets');
            end
        end
        
        function executeBeforeFinalization(obj)
            % Run the statistical test
            
            s = Simulation.getInstance();
            
            fprintf('--------------------------------------------------\n');
            fprintf('--- STATISTICAL ANALYSIS -------------------------\n');
            fprintf('--------------------------------------------------\n');
            
            % We run the test on the primary performance measures only
            obj.test.perform_test(s.datasets.getNames(), s.algorithms.getNames(), cellfun(@(x)x{1}.getFinalizedValue(), s.performanceMeasures)');
            
            fprintf('\n');
            
        end

        function s = getDescription(obj)
            s = sprintf('Run the following statistical test on the results: %s', obj.test.getDescription());
        end
    end
    
end

