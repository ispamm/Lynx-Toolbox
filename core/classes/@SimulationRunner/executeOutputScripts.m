
% EXECUTEOUTPUTSCRIPS Execute the requested output scripts

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function obj = executeOutputScripts( obj )

    if(~isempty(obj.outputScripts))

        fprintf('--------------------------------------------------\n');
        fprintf('--- USER-DEFINED OUTPUT --------------------------\n');
        fprintf('--------------------------------------------------\n');

        for i=1:length(obj.outputScripts)
            eval(obj.outputScripts{i});
        end

    end

end

