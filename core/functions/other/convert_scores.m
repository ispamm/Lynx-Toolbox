
% convert_scores - Convert confidence scores in labels depending on the task.
% If the task if R, labels are the same as scores. If the task is binary
% classification, the labels are given by the sign of the scores. If the
% task if multi-class classification, the labels are the indices of the
% maximum confidence score for each sample.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function labels = convert_scores( scores, t )

if t == Tasks.R
    labels = scores;
elseif t == Tasks.BC
    labels = sign(scores);
else
    labels = vec2ind(scores');
    labels = labels';
end

end

