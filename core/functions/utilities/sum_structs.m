
% sum_structs - average all the numerical elements contained in a cell array of identical structures
%
%   RES = SUM_STRUCTS(S) takes an Nx1 array of identical structures. RES is
%   a struct with the following characteristics: if s is a numeric field in
%   the original structures (double, array or matrix), the field s in RES
%   is the corresponding average over the N original structures. Instead,
%   if s is a non-numeric field, an Nx1 cell array with all the
%   corresponding values is saved in RES with fieldname s. If S is not a
%   cell array, then RES = S.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function res = sum_structs( s )

    if(~iscell(s))
        res = s;
        return;
    end
    

    if(~isempty(s{1}))
        % Get the field names of the structures
        fields = fieldnames(s{1});
    else
        fields = [];
    end
    
    % Divide numeric and non-numeric data
    fieldsNumericIndexes = ones(length(fields), 1);
    for i=1:length(fields)
        if(~isnumeric(s{1}.(fields{i})))
            fieldsNumericIndexes(i) = 0;
        end
    end
    
    % We initialize the resulting structure
    res = struct();
    for i=1:length(fields)
        if(fieldsNumericIndexes(i))
            res.(fields{i}) = zeros(size(s{1}.(fields{i})));
        else
            res.(fields{i}) = cell(1, length(s));
        end
    end
    
    % We sum over all the structures
    for i=1:length(s)
       currentStruct = s{i};
       for j=1:length(fields)
           if(fieldsNumericIndexes(j))
                res.(fields{j}) = res.(fields{j}) + currentStruct.(fields{j});
           else
               res.(fields{j}){i} = currentStruct.(fields{j});
           end
       end
    end
    
    % We normalize the result
    for i=1:length(fields)
        if(fieldsNumericIndexes(i))
            res.(fields{i}) = res.(fields{i})./length(s);
        end
    end
    
end

