
%GENERATE_LATEX_TABLE Create a table of results in a latex file.
%
%   GENERATE_LATEX_TABLE(FILEID, FIELDS, DATANAMES, ALGONAMES, CAPTION,
%   LABEL) writes on the .tex file identified by the handle FILEID, and
%   generates a table where each row is a dataset (names are in DATANAMES)
%   and each column an algorithm (names are in ALGONAMES). Numerical values
%   are taken from FIELDS. CAPTION and LABEL are the caption and label of
%   the table respectively.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function generate_latex_table(fID, fields, datasets_names, algorithms_names, caption, label)


fprintf(fID, '\\begin{table*}[ht]\n');
fprintf(fID, '{\\footnotesize\\centering\\hfill{}\n');

N_algo = length(algorithms_names);
N_data = length(datasets_names);

tmp = 'l';
for i=1:N_algo
    tmp = strcat(tmp, 'l');
end
fprintf(fID, '\\rotatebox{90}{');
fprintf(fID, '\\begin{tabular}{%s}\n', tmp);
fprintf(fID, '\\toprule\n');

fprintf(fID, 'Dataset');
for i=1:N_algo
    fprintf(fID, ' & %s', algorithms_names{i});
end
fprintf(fID, '\\\\ \n');

for i=1:N_data
    fprintf(fID, '\\midrule\n');
    fprintf(fID, '\\multirow{2}{*}{%s}', datasets_names{i});
    for j=1:N_algo
        fprintf(fID, ' & $%f$', mean(fields(j, i, :)));
    end
    
    fprintf(fID, '\\\\ \n');
    
    for j=1:N_algo
        fprintf(fID, ' & $\\pm %f$', std(fields(j, i, :)));
    end
    fprintf(fID, '\\\\ \n');
    
end

fprintf(fID, '\\bottomrule\n\\end{tabular}}}\n\\hfill{}\\vspace{0.6em}\n');
fprintf(fID, '\\caption{%s}\n', caption);
fprintf(fID, '\\label{%s}\n', label);
fprintf(fID, '\\end{table*}\n');


end

