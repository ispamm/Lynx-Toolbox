% CustomContainer - Container for objects having id/name properties
%
% To construct a CustomContainer:
%
%   c = CustomContainer();
%
% To store an element:
%
%   c = c.addElement(o);
%
% To retrieve the index of an element given its id/name:
%
%   idx = c.findById(o);
%   idx = c.findByName(o);
%
% To get/set the elements in the i-th position:
%
%   o = c.get(i);
%   c = c.set(i, o);
%
% To remove an element:
%
%   c = c.remove(id);

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef CustomContainer
    
    properties
        container; % Internal container (cell array)
    end
    
    
    methods
        
        function obj = CustomContainer()
            obj.container = {};
        end
        
        function obj = addElement(obj, a)
            % Add an element, verifies that the id is not already present
            try
                obj.findById(a.id);
                error('Lynx:Runtime:IdAlreadyExisting', 'The id %s is already present', a.id);
            catch
            end
            
            obj.container{end + 1} = a;
        end
        
        function n = findById(obj, id)
            % Get an element by id
            for i = 1:length(obj.container)
                if(strcmp(obj.container{i}.id, id))
                    n = i;
                    return;
                end
            end
            error('Lynx:Runtime:ElementNotFound', 'Element %s not declared', id);
        end
        
        function n = findByIdWithRegexp(obj, id)
            % Get all elements whose id match the given regular expression
            n = [];
            for i = 1:length(obj.container)
                a = regexp(obj.container{i}.id, id, 'match');
                b = ~isempty(a) && strcmp(obj.container{i}.id, a);
                if(b)
                    n = [n; i];
                end
            end
        end
        
        function c = getById(obj, id)
            % Return the element with a given id
            c = obj.container{obj.findById(id)};
        end
        
        function c = get(obj, n)
            % Get the n-th element
            c = obj.container{n};
        end
        
        function obj = set(obj, n, o)
            % Set the n-th element
            obj.container{n} = o;
        end
        
        function obj = remove(obj, id)
            % Remove an element
            id = obj.findById(id);
            obj.container(id) = [];
        end
        
        function names = getNames(obj)
            % Get all names
            names = {};
            for ii = 1:length(obj.container)
                names{ii} = obj.container{ii}.name;
            end
        end
        
        function n = length(obj)
            n = length(obj.container);
        end
        
    end
    
end