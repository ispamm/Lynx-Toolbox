%PLOTFIELD Plot a given field of a struct for all the elements in an array.
%
% CM = PLOT_FIELD(STAT, FIELD, TITLE, AXES, LEGEND) takes an N-dimensional
% array of structs STAT, and plot the property FIELD, using one line for
% every element. TITLE is the title of the resulting figure. AXES is 2x1
% cell array of labels for the axes, and LEGEND is a Nx1 cell array of
% labels for the legend. Return CM, a 3xN array of colors used in plotting.
%
%   CM = PLOT_FIELD(STAT, FIELD, TITLE, AXES, LEGEND, CM) is the same as
%   before, but plot the fields using the color map CM provided by the user.
%
% See also HSV, PLOT

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function colorMap = plot_field( stat, field, figureTitle, figureAxes, figureLegend, colorMap )

    if(isempty(stat) || ~isnumeric(stat{1}.(field)))
        return;
    end

    nAlgo = length(stat);
    
    % Generates color map if not provided
    if(nargin < 6)
        colorMap = hsv(nAlgo);
    end
    
    % Create the figure
    fHandle = figure;
    hold on;
    figshift;
    
    % Set title and labels
    title(figureTitle, 'FontSize', 24);
    xlabel(figureAxes{1}, 'FontSize', 24);
    ylabel(figureAxes{2}, 'FontSize', 24);
    
    % Set other properties
    set(fHandle, 'Color', 'white');
    set(gca, 'FontSize', 24);
    grid on;
    
    % Plot data
    for i = 1:nAlgo
        plot(stat{i}.(field), 'LineWidth', 3, 'Color', colorMap(i,:));
    end
    
    % Set legend
    legend(figureLegend);


end