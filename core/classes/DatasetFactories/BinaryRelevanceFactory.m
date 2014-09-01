% BinaryRelevanceFactory - Factory for multilabel tasks
%   BinaryRelevanceFactory loads a multilabel task by splitting it into
%   multiple binary classification tasks.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef BinaryRelevanceFactory < DatasetFactory

    methods

        function datasets = create(obj, task, data_id, data_name, o)

            nLabels = size(o.Y, 2);
            newX = o.X;
            newtask = Tasks.BC;
            datasets = cell(nLabels, 1);
            
            for j=1:nLabels
                newY = o.Y(:, j);
                newname = sprintf('%s (%s)', data_name, o.labels_info{j});
                newID = sprintf('%s-%d', data_id, j);
                datasets{j} = Dataset(newID, newname, newtask, newX, newY);
            end
            
            fprintf('Extracted %i different binary classification datasets from original dataset %s\n', nLabels, data_name);
            
        end
    end
    
end

