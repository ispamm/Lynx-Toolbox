function set_statistical_test( stat_test )
%SET_STATISTICAL_TEST Set the current statistical testing procedure.
%Parameter must be aa point to a class deriving from StatisticalTest.

assert(isa(stat_test(), 'StatisticalTest'), 'LearnToolbox:WrongInput:InvalidStatisticalTesting', ...
    'The statistical testing is invalid, please ensure it is an object of class StatisticalTest');

log = SimulationLogger.getInstance();
log.statistical_test = stat_test;

end

