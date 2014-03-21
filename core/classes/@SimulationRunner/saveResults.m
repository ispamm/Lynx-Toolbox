
% SAVERESULTS If requested by the user, save the results of the simulation

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it
% and/or generates the pdf

function obj = saveResults( obj )

    log = SimulationLogger.getInstance();
    if(log.flags.save_results || log.flags.generate_pdf)
        
        % Generate folder
        resultFolder = strcat('./results/', obj.simulationName, '/');
        mkdir(resultFolder);

        if(log.flags.save_results)
            fprintf('Saving workspace...\n');
            resultsFile = strcat(resultFolder, 'results.mat');
            save(resultsFile);
            
            % Close the diary
            diary('off');
            
            % Close the workers so that we can move the file
            if(log.flags.parallelized)
                matlabpool close;
            end
            
            % Move the verbatim file or delete it
            movefile(strcat('tmp/',obj.verbatimFile), resultFolder);
        end
        
        % Note: this requires pdflatex available on the system path
        if(log.flags.generate_pdf)
            fprintf('Saving Latex source code...\n');
            resultsFile = strcat('results_latex');
            generate_latex_code(resultsFile, resultFolder, obj.trainingTime, obj.computedError, obj.getDatasetsNames(), obj.getAlgorithmsNames());     
        end 
    end

end

