% SingletonClass - A class implementing the Singleton pattern
%   Any class extending the SingletonClass can have a single instance
%   in a program, which can be retrieved using the static getInstance
%   method. The class offers two additional methods:
%
%   clear - Clear the current instance
%   copyConfiguration - Copy the internal properties of the instance from
%   another instance (this is used for parfor loops)
%
%   For extending this class, two steps are needed:
%
%   1) Declare a constant 'singleton_id' property, which is the name of the
%   instance of the Singleton class. This property must be unique along all
%   possible classes implementing the Singleton class.
%
%   2) A method getInstanceFromClass for obtaining an instance. To see a
%   possible implementation of this method, see BinaryClassificationTask or
%   any other class extending it.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef SingletonClass < handle
    
    properties(Abstract,Access=protected,Constant)
        % Unique string identifying the instance of the Singleton
        singleton_id;
    end
    
    methods (Access = protected)
        % Protected constructor
        function obj = SingletonClass()
        end
    end
    
    methods
        
        function clear(obj)
            % Clear the current instance of the Singleton
            eval(sprintf('global %s', obj.singleton_id));
            eval(sprintf('%s = [];', obj.singleton_id));
        end
        
        function copyConfiguration(obj, currentSingleton)
            f = obj.fields;
            for i = 1:length(f)
                obj.(f{i}) = currentSingleton.(f{i});
            end
        end
        
    end
    
    methods (Static)
        function singleObj = getInstanceFromClass(c)
            % Retrieve an instance of a Singleton of a given class. Due to
            % the structure, this can be called only inside getInstance().
            eval(sprintf('global %s', c.singleton_id));
            eval(sprintf('if(isempty(%s) || ~isvalid(%s)) %s = c; end;', c.singleton_id, c.singleton_id, c.singleton_id));
            eval(sprintf('singleObj = %s;', c.singleton_id));
        end
        
    end
    
    methods(Abstract,Static)
        % Retrieve the global instance of the Singleton
        singleObj = getInstance();
    end
    
end