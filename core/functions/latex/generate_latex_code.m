
%GENERATE_LATEX_CODE Create a Latex file containing two tables with the
%results of a simulation, then compile it.
%
%   GENERATE_LATEX_CODE(FILEPATH, FOLDER, TRAININGTIME, ERROR, DATANAMES,
%   ALGONAMES) generates a .tex file in FOLDER with name FILEPATH. Errors
%   and training time are taken from the matrices TRAININGTIME and ERROR,
%   while the names of the datasets and algorithms are taken from the cell
%   arrays DATANAMES and ALGONAMES. This is subsequently compiled using 
%   pdflates. Note that this requires pdflatex available on the path.
%
% See also GENERATE_LATEX_TABLE

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function generate_latex_code( resultsFile, resultFolder, trainingTime, error, datasets_names, algorithms_names)

name = strcat(resultFolder, resultsFile, '.tex');

fID = fopen(name, 'wt');

fprintf(fID, '\\documentclass[]{article}\n');

% Required packages
fprintf(fID, '\\usepackage{booktabs}\n');
fprintf(fID, '\\usepackage{multirow}\n');
fprintf(fID, '\\usepackage{graphicx}\n');
fprintf(fID, '\n');

fprintf(fID, '\\begin{document}\n');

% Create the two tables
generate_latex_table(fID, error, datasets_names, algorithms_names, 'Experimental results (Error).', 'tab:results');
fprintf(fID, '\n');
generate_latex_table(fID, trainingTime, datasets_names, algorithms_names, 'Experimental results (Training Time).', 'tab:times');

fprintf(fID, '\\end{document}');

fclose(fID);

fprintf('Compiling Latex...\n');
comm = sprintf('pdflatex %s', name);
[~,~] = system(comm);
[~,~] = system(comm);
delete('*.aux');
delete('*.log');
movefile(strcat(resultsFile, '.pdf'), resultFolder);


end
