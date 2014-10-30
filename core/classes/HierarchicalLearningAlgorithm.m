% HierarchicalLearningAlgorithm - hierarchical learning algorithm (HLA)
%   A HLA is defined by a tree, where each node corresponds to a
%   learning algorithm. Each internal node is a classifier, and the
%   data is split along its children depending on the classification.
%   The relation between the original data and the classes at every
%   internal node is provided by an Aggregator object.
%
% HierarchicalLearningAlgorithm Properties:
%
%   children - A cell array of HierarchicalLearningAlgorithm objects,
%   corresponding to the children of the node.
%
%   aggregator - An Aggregator object, providing the relation between
%   the original output of the problem and the classes at the given
%   node. If the node is terminal, aggregator is not used.
%
%   learningAlgorithm - A LearningAlgorithm object used to train the
%   internal node.
%
%   name - The name of the node.
%
% LearningAlgorithm Methods:
%
%   addChild - Add a child to the node. To do this, the learning
%   algorithm must support multiclass classification.
%
%   getNArity - Return the number of children of the node.
%
%   size - Return the size of the tree, i.e., the number of nodes of
%   the tree rooted at the node.
%
%   print - Print its internal structure on the console.
%
% See also LEARNINGALGORITHM, AGGREGATOR


% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef HierarchicalLearningAlgorithm < LearningAlgorithm
    
    properties
        children;           % Cell array of children
        aggregator;         % Aggregator object to partition data
        learningAlgorithm;  % Learning algorithm to train the model
        name;               % Name of the node
        id;
    end
    
    methods
        
        function obj = HierarchicalLearningAlgorithm(aggregator, learningAlgorithm)
            obj = obj@LearningAlgorithm([]);
            obj.children = {};
            obj.aggregator = aggregator;
            obj.learningAlgorithm = learningAlgorithm;
            obj.name = learningAlgorithm.name;
            obj.id = learningAlgorithm.id;
        end
        
        function obj = addChild(obj, node)
            % Add a child to the node
            
            % To have children, the learning algorithm must support
            % multiclass classification
            if(obj.learningAlgorithm.isDatasetAllowed(Dataset(RealMatrix([]), [], Tasks.MC)))
                obj.children{end+1} = node;
            else
                error('Lynx:TaskIncompatibility:HierarchicalLearningModelError', 'To add a children to a hierarchical learning algorithm, its base learning algorithm must support multiclass classification');
            end
        end
        
        function n = getNArity(obj)
            % Returns the number of children of the tree
            n = length(obj.children);
        end
        
        function n = size(obj)
            % Get the size of the tree rooted at the node
            n = 1;
            for i = 1:obj.getNArity()
                n = n + obj.children{i}.size();
            end
        end
        
        function p = initParameters(~, p)
        end
        
        function obj = train(obj, d)
            
            log = SimulationLogger.getInstance();
            
            % This is used to check how many nodes are left to train. A
            % variable with name "treeSizeVariableName" is set in the
            % SimulationLogger when analyzing the root node, with the total
            % size of the tree. Then, the variable is decremented at every
            % other node.
            treeSizeVariableName = 'treeLength';
            
            if(log.flags.debug)
                
                treeSize = log.getAdditionalParameter(treeSizeVariableName);
                
                if(isempty(treeSize) || treeSize - 1 == 0)
                    log.setAdditionalParameter(treeSizeVariableName, obj.size());
                    treeSize = obj.size();
                else
                    log.setAdditionalParameter(treeSizeVariableName, treeSize - 1);
                    treeSize = treeSize - 1;
                end
                
                fprintf('\t\t Training algorithm %s (%i node(s) left)...\n', obj.name, treeSize);
                
            end
            
            % If this is a terminal node, we set the original task. If this
            % is a non-terminal node, we group the output and set a
            % multiclass classification task.
            if(obj.getNArity() == 0)
                groups = d.Y.data;
            else
                groups = obj.aggregator.group(d.Y.data);
            end
            
            obj.learningAlgorithm = obj.learningAlgorithm.train(Dataset(d.X, IntegerLabelsVector(groups), Tasks.MC));
            
            % Train all the children (if there is at least one)
            if(~isempty(obj.children))
                for i = 1:obj.getNArity()
                    obj.children{i} = obj.children{i}.train(Dataset(d.X.data(groups == i, :), d.Y.data(groups == i), obj.task));
                end
            end
            
        end
        
        function b = hasCustomTesting(~)
            b = true;
        end
        
        function [labels, scores] = test_custom(obj, d)
            
            [orig_labels, scores] = obj.learningAlgorithm.test(d);
            labels = orig_labels;
            % If there are children, compute the final labels.
            % TODO: Compute the correct scores.
            if(~isempty(obj.children))
                for i = 1:obj.getNArity()
                    currentSplit = orig_labels == i;
                    [currentLabels, ~] = ...
                        obj.children{i}.test(Dataset(d.X.data(currentSplit, :), [], obj.task));
                    labels(currentSplit) = currentLabels;
                end
            end
        end
        
        function res = isDatasetAllowed(obj, d)
            % Check if the task is allowed
            
            % A task is allowed if it is allowed at every terminal node
            if (obj.getNArity() == 0)
                res = obj.learningAlgorithm.isDatasetAllowed(d);
            else
                res = true;
                for i=1:obj.getNArity()
                    res = res & obj.children{i}.isDatasetAllowed(d);
                end
            end
        end
        
        function res = checkForCompatibility(obj, model)
            % A model is compatible if it is compatible with every node
            if (obj.getNArity() == 0)
                res = obj.learningAlgorithm.checkForCompatibility(model);
            else
                res = true;
                for i=1:obj.getNArity()
                    res = res & obj.children{i}.checkForCompatibility(model);
                end
            end
        end
        
        function print(obj)
            obj.print_recursively(0, '');
        end
        
        function print_recursively(obj, currentLevel, currentHeader)
            
            % This code is protected by a wizard. Please
            % do not touch.
            %
            %                        .
            %              /^\     .
            %         /\   "V"
            %        /__\   I      O  o
            %       //..\\  I     .
            %       \].`[/  I
            %       /l\/j\  (]    .  O
            %      /. ~~ ,\/I          .
            %      \\L__j^\/I       o
            %       \/--v}  I     o   .
            %       |    |  I   _________
            %       |    |  I c(`       ')o
            %       |    l  I   \.     ,/
            %     _/j  L l\_!  _//^---^\\_
            %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            % ASCII artist: Rowan Crawford
            
            if(obj.getNArity() == 0)
                fprintf('%s\n', obj.name);
            else
                fprintf('%s [%s]\n', obj.name, class(obj.aggregator));
            end
            spaces = repmat(' ', 1, floor(length(obj.name)/2));
            newHeader = [currentHeader, spaces, '|'];
            for i=1:obj.getNArity()
                fprintf(newHeader); fprintf('\n');
                fprintf(newHeader); cprintf('err', ' %s\n', obj.aggregator.getInfo(i));
                fprintf(newHeader); fprintf('---> ');
                if(i == obj.getNArity())
                    obj.children{i}.print_recursively(currentLevel + 1, [currentHeader, spaces, '    ']);
                else
                    obj.children{i}.print_recursively(currentLevel + 1, [newHeader, '    ']);
                end
            end
        end
        
        function s = getInstanceDescription(obj)
            s = sprintf('%s (hierarchical algorithm). For its structure, add output script ''info_hla''', obj.name);
        end
        
        function varargout = subsref(A, S)
            [varargout{1:nargout}] = builtin('subsref', A, S);
        end
        
    end
    
    methods(Static)
        
        function info = getDescription()
            info = 'Core class for constructing hierarchical learning algorithms';
        end
        
        function pNames = getParametersNames()
            pNames = {};
        end
        
        function pInfo = getParametersInfo()
            pInfo = {};
        end
        
        function pRange = getParametersRange()
            pRange = {};
        end
        
    end
    
end

