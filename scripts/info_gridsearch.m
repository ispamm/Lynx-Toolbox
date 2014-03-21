
% INFO_GRIDSEARCH Print info on any grid search procedure executed during 
% the simulation

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

algos = find_algorithms('ParameterSweep', obj.algorithms);

for i = algos
   cprintf('*text', 'Results of grid search for algorithm %s: \n', obj.algorithms(i).name);
   
   for j = 1:length(obj.datasets)
       
       fprintf('\tDataset %s:\n', obj.datasets{j}.name);
       algo_stats = cell(obj.nRuns, 1);
       
       for z = 1:obj.nRuns
           algo_stats{z} = obj.trainedAlgo{i, j, z}{1}.statistics;
       end
       
       algo_stats = sum_structs(algo_stats);
       fprintf('\t\tAverage training time is %f sec\n', algo_stats.finalTrainingTime);
       
       params_gs = obj.trainedAlgo{i, j, z}{1}.getTrainingParam('parameterNames');
       
       for z = 1:length(params_gs{1})
          
           tmp = 0;
           for zz = 1:obj.nRuns
                tmp = tmp + obj.trainedAlgo{i, j, zz}{1}.getTrainingParam(params_gs{1}{z});
           end
           tmp = tmp/obj.nRuns;
           
           fprintf('\t\t%s = %f\n', params_gs{1}{z}, tmp);
           
       end
       
   end
   
end
    