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

        function datasets = process(obj, d)

            nLabels = size(d.Y.data, 2);
            newX = d.X;
            
            newtask = Tasks.BC;
            datasets = cell(nLabels, 1);
            
            for j=1:nLabels
                newY = d.Y.data(:, j);
                newname = sprintf('%s (%s)', data_name, d.labels_info{j});
                newID = sprintf('%s-%d', data_id, j);
                datasets{j} = Dataset(newX, BinaryLabelsVector(newY), newtask);
                datasets{j} = datasets{j}.setIdAndName(newID, newname);
            end
            
            fprintf('Extracted %i different binary classification datasets from original dataset %s\n', nLabels, data_name);
            
        end
    end
    
end

