% PLOT_DECISION_BOUNDARIES - Plot the decision boundaries for 2D datasets
%   This script plots the decision boundaries for every 2D 
%   binary classification dataset in the simulation. Only a single boundary
%   is plotted (corresponding to the first run / first fold).

s = Simulation.getInstance();

% General plotting instruction
marker_size = 8;
line_width = 2;
boundary_resolution = 0.05;

datasets = s.datasets;

for ii = 1:datasets.length
    % Check if the dataset is 2D
    data2d = size(datasets.get(ii).X.data, 2) == 2 && datasets.get(ii).task == Tasks.BC;
    
    if(data2d)
       
        % Get partitioning of the dataset
        d = datasets.get(ii);
        d = d.setCurrentPartition(1);
        [d_train, d_test, d_u] = d.getFold(1);
        X = [d_train.X.data; d_test.X.data; d_u.X.data];
                    
        % Get the boundaries
        xlim = [min(X(:, 1)) max(X(:, 1))];
        ylim = [min(X(:, 2)) max(X(:, 2))];
        xrange = xlim(1):boundary_resolution:xlim(2);
        yrange = ylim(1):boundary_resolution:ylim(2);
        
        for jj = 1:s.algorithms.length
           
            % Get current algorithm
            current_algo = s.trainedAlgo{ii, jj, 1}{1};
            
            % Initialize the plot
            figure(); hold on; figshift;
            title(sprintf('Decision boundary of %s (dataset %s)', current_algo.name, d.name));
            
            % Set the colour map
            cmap = [1 0.8 0.8; 0.95 1 0.95; 0.9 0.9 1];
            colormap(cmap);
            
            % Compute grid
            [x, y] = meshgrid(xrange, yrange);
            
            % Get the scores
            [labels, ~] = current_algo.test(Dataset(RealMatrix([x(:) y(:)]), [], Tasks.BC));
            decision_map = reshape(labels, size(x));
            
            % Plot the boundary
            imagesc(xrange, yrange, decision_map);
            hold on;
            set(gca, 'ydir', 'normal');

            % Plot unlabeled data
            plot(d_u.X.data(:, 1), d_u.X.data(:, 2), 'og', 'MarkerSize', marker_size, 'LineWidth', line_width);
            
            % Plot test data
            plot(d_test.X.data(d_test.Y.data == 1, 1), d_test.X.data(d_test.Y.data == 1, 2), 'xb', 'MarkerSize', marker_size + 1, 'LineWidth', line_width);
            plot(d_test.X.data(d_test.Y.data == -1, 1), d_test.X.data(d_test.Y.data == -1, 2), 'xr', 'MarkerSize', marker_size + 1, 'LineWidth', line_width);
            
                        
            % Plot training data
            plot(d_train.X.data(d_train.Y.data == 1, 1), d_train.X.data(d_train.Y.data == 1, 2), 'sb', 'MarkerSize', marker_size + 1, 'LineWidth', line_width);
            plot(d_train.X.data(d_train.Y.data == -1, 1), d_train.X.data(d_train.Y.data == -1, 2), 'sr', 'MarkerSize', marker_size + 1, 'LineWidth', line_width);
            
            legend('Train (+1)', 'Train (-1)', 'Unlabeled', 'Test (+1)', 'Test (-1');
            
            
        end
        
    end

end

