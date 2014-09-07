
% check_compatibility - Verify compatibility of algorithms and datasets
%   Verify that the chosen algorithms and datasets are compatibles. In case
%   this is not verified, set the internal property fullCompatibility to 
%   false, and print on screen the inconsistencies.

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
        tmp = obj.algorithms.get(i).isDatasetAllowed(obj.datasets.get(j));
        if(~tmp)
           
            % If res is true, this is the first inconsistency which has
            % been found
            if(res)
                cprintf('err', 'The following tests are not possible:\n');
                res = false;
            end
            
            cprintf('err', '\t %s on %s.\n', obj.algorithms.get(i).name, obj.datasets.get(j).name);
            
        end
        
    end
    
end

% This boolean indicates whether at least one inconsistency has been found
obj.fullCompatibility = res;

end
