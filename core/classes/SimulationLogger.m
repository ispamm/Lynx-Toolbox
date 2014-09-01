% SimulationLogger - A class for storing and retrieving data from any point of the program execution 
% Note that stored values in separate threads are not accessible
% whenever the thread is closed.
%
%   SimulationLogger Methods:
%
%   setAdditionalParameter/addAdditionalParameter - Insert a parameter
%   in the logger, and retrieve it successively.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef (Sealed) SimulationLogger < SingletonClass
   
    properties
       % Data structure containing the additional parameters
       additionalParameters;
       % Flags for the run
       flags;
    end
    
    properties(Access=protected,Constant)
        singleton_id = 'simlogger_singleton_id';
    end
    
    methods (Access = private)
      function obj = SimulationLogger()
          obj.additionalParameters = containers.Map;
          obj.flags = struct('debug', true, 'semisupervised', false, 'parallelized', false);
      end
    end
    
    methods (Static)
      function singleObj = getInstance()
         singleObj = SingletonClass.getInstanceFromClass(SimulationLogger());
      end
    end
    
    methods
        
      function value = getAdditionalParameter(obj, key)
          % Get a parameter stored in the logger. If the parameter does not
          % exist, returns an empty array.
          if(obj.additionalParameters.isKey(key))
            value = obj.additionalParameters(key);
          else
              obj.additionalParameters(key) = [];
              value = [];
          end
      end
      
      function obj = setAdditionalParameter(obj, key, value)
          % Set an additional key/value pair
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
      
   end
   
end