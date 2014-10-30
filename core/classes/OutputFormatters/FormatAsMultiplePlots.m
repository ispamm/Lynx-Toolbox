% FormatAsMultiplePlots - Display multiple plots
%   This is a possible output formatter for the type XYPlot.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef FormatAsMultiplePlots < OutputFormatter
    
    methods(Static)
        
        function displayOnConsole(valuesCellArray, row_labels, column_labels, print)
            
            if(nargin == 3)
                print = true;
            end
            
            if(nargin < 4 && print)
                fprintf('See plots\n');
            end
            
            N_r = length(row_labels);
            N_c = length(column_labels);
            

            for ii = 1:N_r
                
                % Generates color map
                colorMap = hsv(N_c);
                
                % Create the figure
                fHandle = figure();
                hold on;
                
                % Shifht slightly the figure
                figshift;
                
                % Set title and labels
                title(sprintf('%s', row_labels{ii}), 'FontSize', 24);
                v = valuesCellArray{ii, 1}.getFinalizedValue();
                xlabel(v.x_label, 'FontSize', 24);
                ylabel(v.y_label, 'FontSize', 24);
                
                % Set other properties
                set(fHandle, 'Color', 'white');
                set(gca, 'FontSize', 18);
                grid on;
                
                % Plot data
                for jj = 1:N_c
                    o = valuesCellArray{ii, jj}.getFinalizedValue();
                    if(length(o.X) == 1)
                        plot(o.X, o.Y, 'x', 'MarkerSize', 15, 'LineWidth', 3, 'MarkerEdgeColor', colorMap(jj,:));
                    else
                        plot(o.X, o.Y, 'LineWidth', 3, 'Color', colorMap(jj,:));
                    end
                end
                
                % Set axis scaling
                axis tight;
                
                % Set legend
                legend(column_labels);

            end
            
            if(nargin < 4 && print)
                fprintf('\n');
            end
            
        end
    end
    
end

