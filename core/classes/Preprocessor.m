classdef Preprocessor
    % Preprocessor An abstract class for creating a preprocessor for a
    % dataset. The preprocessor is applied to the dataset before training
    % the algorithms.
    %
    % Preprocessor Methods
    %
    %   process - Given a dataset, applies a given transformation and
    %   returns the new dataset.
    %
    %   getInfo - Return a string describing the preprocessor, plus a cell
    %   array of strings describing each of the parameters to be passed to
    %   the preprocessor.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it

    properties
        params;     
    end
    
    methods
        
        
        function obj = Preprocessor(varargin)
            p = inputParser;
            initParameters(obj, p);
            if(~isempty(varargin{:})) % Needed for the report
                p.parse(varargin{:}{:}{:});
            end
            obj.params = p.Results;
        end
        
    end
    
    methods(Abstract=true)
        
        initParameters(obj, p);
        dataset = process(obj, dataset);
    
    end
    
    methods(Abstract,Static)
        
        info = getInfo()                % Get information on the algorithm
        pNames = getParametersNames()   % Get the name of the parameters
        pInfo = getParametersInfo()     % Get info on the parameters
        pRange = getParametersRange()   % Get info on the possible values of the parameters
    
    end
    
end

