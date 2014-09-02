
% INFO_GRIDSEARCH Print info on any grid search procedure executed during 
% the simulation

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

PRINT_GRAPHS = true;

s = Simulation.getInstance();
algos = find_algorithms('ParameterSweep', s.algorithms);

for i = algos
   cprintf('*text', 'Results of grid search for algorithm %s: \n', s.algorithms.get(i).name);
   
   for j = 1:length(s.datasets)
       
       fprintf('\tDataset %s:\n', s.datasets.get(j).name);
       algo_stats = cell(s.nRuns, 1);
       
       for z = 1:s.nRuns
           algo_stats{z} = s.trainedAlgo{j, i, z}{1}.statistics;
       end
       
       algo_stats = sum_structs(algo_stats);
       fprintf('\t\tAverage training time is %.2f sec\n', algo_stats.finalTrainingTime);
       
       params_gs = s.trainedAlgo{j, i, z}{1}.getParameter('parameterNames');
       
       for z = 1:length(params_gs{1})
          
           tmp = 0;
           for zz = 1:s.nRuns
                tmp = tmp + s.trainedAlgo{j, i, zz}{1}.getParameter(params_gs{1}{z});
           end
           tmp = tmp/s.nRuns;
           
           fprintf('\t\t%s = %f\n', params_gs{1}{z}, tmp);
           
       end
       
       if(PRINT_GRAPHS)
           valErrorGrid = algo_stats.valErrorGrid;
           if(isvector(valErrorGrid))
               figure(); hold on; figshift;
               b = s.trainedAlgo{j, i, 1}{1}.getParameter('ranges');
               plot( b{1}{1}, valErrorGrid);
               xlabel(params_gs{1});
               ylabel('Validation error');
               title(sprintf('Algorithm %s on dataset %s', s.algorithms.get(i).name, s.datasets.get(j).name));
           elseif(ismatrix(valErrorGrid))
               figure(); hold on; figshift;
               b = s.trainedAlgo{j, i, 1}{1}.getParameter('ranges');
               surf( b{1}{1}, b{1}{2}, valErrorGrid');
               xlabel(params_gs{1}{1});
               ylabel(params_gs{1}{2});
               zlabel('Validation error');
               title(sprintf('Algorithm %s on dataset %s', s.algorithms.get(i).name, s.datasets.get(j).name));
           end
       end
       
   end
   
end
    