
% CHECK_COMPATIBILITY Verify if a set of algorithms can be executed on a
% set of datasets, and print on screen the eventual inconsistencies.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

function obj = check_compatibility(obj)

res = true;

for i=1:length(obj.algorithms)
    
    for j=1:length(obj.datasets)
       
        % tmp is a boolean indicating if the j-th dataset is compatible
        % with the i-th algorithm
        tmp = obj.algorithms(i).model.isTaskAllowed(obj.datasets{j}.task);
        if(~tmp)
           
            % If res is true, this is the first inconsistency which has
            % been found
            if(res)
                cprintf('err', 'The following tests are not possible:\n');
                res = false;
            end
            
            cprintf('err', '\t %s on %s.\n', obj.algorithms(i).name, obj.datasets{j}.name);
            
        end
        
    end
    
end

% This boolean indicates whether at least one inconsistency has been found
obj.fullCompatibility = res;

end
