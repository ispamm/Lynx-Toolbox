% XYPlot - X-Y values of a plot with axis labels
%   This is a commodity class for storing the values for an x-y plot.
%   Construct it as:
%
%   c = XYPlot(X, Y, x_label, y_label), where X and Y are the values of the
%   plot and x_label and y_label the labels for the axis. Both labels are
%   optional.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef XYPlot
    
    properties
        X;          % X values
        Y;          % Y values
        x_label;    % Label on the x-axis
        y_label;    % Label on the y-axis
    end
    
    methods
        
        function obj = XYPlot(X, Y, x_label, y_label)
            % Construct the XYPlot object
            if(nargin < 3)
                obj.y_label = [];
                obj.x_label = [];
            elseif(nargin < 4)
                obj.x_label = x_label;
                obj.y_label = [];
            else
                obj.x_label = x_label;
                obj.y_label = y_label;
            end
            obj.X = X;
            obj.Y = Y;
        end
    end
    
end

