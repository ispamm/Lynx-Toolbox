classdef (Sealed) SimulationLogger < handle
    % Logger A class implementing the Singleton pattern for storing and
    % retrieving data from any point of the program execution. Note that
    % stored values in separate threads are not accessible whenever the
    % thread is closed.
    %
    %   SimulationLogger Methods:
    %
    %   getInstance - Returns the only allowed instance of the class
    %
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
   
    properties
       algorithms; 
       datasets;
       performanceMeasures;
       additionalParameters;
       flags;
       partition_strategy;
    end
    
    methods (Access = private)
      function obj = SimulationLogger
          obj.additionalParameters = containers.Map;
          obj.flags = struct('debug', true, 'parallelized', false, 'gpu_enabled', false, 'save_results', false, 'generate_pdf', false, 'semisupervised', false);
          obj.algorithms = struct('id', {}, 'name', {}, 'model', {});
          obj.datasets = cell(0,0);
          obj.performanceMeasures = containers.Map;
          obj.performanceMeasures(char(Tasks.BC)) = @PerfMisclassification;
          obj.performanceMeasures(char(Tasks.MC)) = @PerfMisclassification;
          obj.performanceMeasures(char(Tasks.R)) = @PerfNrmse;
          obj.partition_strategy = KFoldPartition(3);
      end
    end
    
    methods
        
      function copyConfiguration(obj, currentLogger)
         obj.performanceMeasures = currentLogger.performanceMeasures;
         obj.additionalParameters = currentLogger.additionalParameters;
         obj.flags = currentLogger.flags;
      end
        
      function value = getAdditionalParameter(obj, key)
          if(obj.additionalParameters.isKey(key))
            value = obj.additionalParameters(key);
          else
              obj.additionalParameters(key) = [];
              value = [];
          end
      end
      
      function obj = setAdditionalParameter(obj, key, value)
          obj.additionalParameters(key) = value;
      end
      
      function obj = appendToAdditionalParameter(obj, key, value)
          p = obj.getAdditionalParameter(key);
          if(isempty(p))
              p = cell(1,1);
              p{1} = value;
          else
              if(iscell(p))
                p{end+1} = value;
              else
                  p = {p};
                  p{end+1} = value;
              end
          end
          obj.setAdditionalParameter(key, p);
      end
      
      function obj = clear(~)
          global localObj
          localObj = [];
      end
      
      function n = findDatasetById(obj, id)
         for i = 1:length(obj.datasets)
             if(strcmp(obj.datasets{i}.id, id))
                 n = i;
                 return;
             end
         end
         error('LearnTool:Validation:DatasetNotDeclared', 'Dataset %s not declared', id);
      end
      
      function n = findDatasetByIdWithRegexp(obj, id)
         n = [];
         for i = 1:length(obj.datasets)
             a = regexp(obj.datasets{i}.id, id, 'match');
             b = ~isempty(a) && strcmp(obj.datasets{i}.id, a);
             if(b)
                 n = [n; i];
             end
         end
      end
      
      function n = findAlgorithmById(obj, id)
         for i = 1:length(obj.algorithms)
             if(strcmp(obj.algorithms(i).id, id))
                 n = i;
                 return;
             end
         end
         error('LearnTool:Validation:AlgorithmNotDeclared', 'Algorithm %s not declared', id);
      end
      
    end
   
   methods (Static)
      function singleObj = getInstance
         global localObj
         if isempty(localObj) || ~isvalid(localObj)
            localObj = SimulationLogger;
         end
         singleObj = localObj;
      end
   end
   
end