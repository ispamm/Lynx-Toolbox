
% GET_PARTITION Return the cvpartition corresponding to a given set of
% labels and parameter for subdiving the data.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function cp = get_partition( Y, test_parameter )

if(~(round(test_parameter) == test_parameter))
    kfold = false;
else
    kfold = true;
end

warning off
if(~kfold)
    cp = cvpartition(Y,'holdout',test_parameter);
else
    cp = cvpartition(Y,'k',test_parameter);
end
warning on

end