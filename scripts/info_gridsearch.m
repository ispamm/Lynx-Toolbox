
% INFO_GRIDSEARCH Print info on any grid search procedure executed during 
% the simulation

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

PRINT_INFO = true;
PRINT_GRAPHS = true;

algos = find_algorithms('ParameterSweep', obj.algorithms);

for i = algos
   cprintf('*text', 'Results of grid search for algorithm %s: \n', obj.algorithms(i).name);
   
   for j = 1:length(obj.datasets)
       
       if(PRINT_INFO)
        fprintf('\tDataset %s:\n', obj.datasets{j}.name);
       end
       
       algo_stats = cell(obj.nRuns, 1);
       
       for z = 1:obj.nRuns
           algo_stats{z} = obj.trainedAlgo{i, j, z}{1}.statistics;
       end
       
       algo_stats = sum_structs(algo_stats);
       
       if(PRINT_INFO)
        fprintf('\t\tAverage training time is %f sec\n', algo_stats.finalTrainingTime);
       end
       
       params_gs = obj.trainedAlgo{i, j, z}{1}.getTrainingParam('parameterNames');
       
       for z = 1:length(params_gs{1})
          
           tmp = 0;
           for zz = 1:obj.nRuns
                tmp = tmp + obj.trainedAlgo{i, j, zz}{1}.getTrainingParam(params_gs{1}{z});
           end
           tmp = tmp/obj.nRuns;
           
           if(PRINT_INFO)
             fprintf('\t\t%s = %f\n', params_gs{1}{z}, tmp);
           end
           
       end

       if(PRINT_GRAPHS)
           valErrorGrid = algo_stats.valErrorGrid;
           if(isvector(valErrorGrid))
               figure(); hold on;
               b = obj.trainedAlgo{i, j, 1}{1}.getTrainingParam('bounds');
               s = obj.trainedAlgo{i, j, 1}{1}.getTrainingParam('steps');
               plot( b(1):s:b(2), valErrorGrid);
               xlabel(params_gs{1});
               ylabel('Validation error');
               title(sprintf('Algorithm %s on dataset %s', obj.algorithms(i).name, obj.datasets{j}.name));
           elseif(ismatrix(valErrorGrid))
               figure(); hold on;
               b = obj.trainedAlgo{i, j, 1}{1}.getTrainingParam('bounds');
               s = obj.trainedAlgo{i, j, 1}{1}.getTrainingParam('steps');
               surf( b(1,1):s(1):b(1, 2), b(2,1):s(2):b(2,2), valErrorGrid');
               xlabel(params_gs{1}{1});
               ylabel(params_gs{1}{2});
               zlabel('Validation error');
               title(sprintf('Algorithm %s on dataset %s', obj.algorithms(i).name, obj.datasets{j}.name));
           end
       end
       
   end
   

end
    