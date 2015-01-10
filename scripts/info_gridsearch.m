
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
    
   p_names = s.trainedAlgo{1, i, 1}{1}.getParameter('parameterNames');
   p_names = p_names{1};
   n_parameters_sweeped = length(p_names);
   
   % Last column is for training time
   params_avg = zeros(length(s.datasets), n_parameters_sweeped + 1);
   
   % Recovering the parameters
   for j = 1:length(s.datasets)
       
       algo_stats = cell(s.nRuns, 1);
       for z = 1:s.nRuns
           algo_stats{z} = s.trainedAlgo{j, i, z}{1}.statistics;
       end
       algo_stats = sum_structs(algo_stats);
       
       params_avg(j, end) = algo_stats.finalTrainingTime;
       
       for z = 1:n_parameters_sweeped
          
           tmp = 0;
           for zz = 1:s.nRuns
                tmp = tmp + s.trainedAlgo{j, i, zz}{1}.getParameter(p_names{z});
           end
           tmp = tmp/s.nRuns;
           
           params_avg(j, z) = tmp;
           
       end
       
       exist_valErrorGrid = length(p_names) <= 2;
       
       if(PRINT_GRAPHS && exist_valErrorGrid)
           valErrorGrid = algo_stats.valErrorGrid;
           b = s.trainedAlgo{j, i, 1}{1}.getParameter('ranges');
           
           % HORRIBLE HACK (for exponential plots)
           if(abs(b{1}{1}(1)*2 - b{1}{1}(2)) < 10^-10 || abs(b{1}{1}(1)*10 - b{1}{1}(2)) < 10^-10)
               exp_1 = true;
           else
               exp_1 = false;
           end
           if(~isvector(valErrorGrid))
               if(abs(b{1}{2}(1)*2 - b{1}{2}(2)) < 10^-10 || abs(b{1}{2}(1)*10 - b{1}{2}(2)) < 10^-10)
                   exp_2 = true;
               else
                   exp_2 = false;
               end
           end
           
           if(isvector(valErrorGrid))
               c = XYPlotContainer();
               c = c.store(XYPlot(b{1}{1}, valErrorGrid, p_names, 'Validation error')); 
               p = FormatAsMultiplePlots();
               p.displayOnConsole({c}, {sprintf('Algorithm %s on dataset %s', s.algorithms.get(i).name, s.datasets.get(j).name)}, {'Performance'}, true, [exp_1, false]);
           else
               figure(); hold on; figshift;
               b = s.trainedAlgo{j, i, 1}{1}.getParameter('ranges');
               if(exp_1)
                   set(gca,'xscale','log');
               end
               if(exp_2)
                   set(gca,'yscale','log');
               end
               surf( b{1}{1}, b{1}{2}, valErrorGrid');
               xlabel(p_names{1});
               ylabel(p_names{2});
               zlabel('Validation error');
               title(sprintf('Algorithm %s on dataset %s', s.algorithms.get(i).name, s.datasets.get(j).name));
           end
       end
       
   end
   
   cprintf('*text', 'Results of grid search for algorithm %s: \n', s.algorithms.get(i).name);
   disptable(params_avg, [p_names, {'T. Time'}], s.datasets.getNames());
   
end
    