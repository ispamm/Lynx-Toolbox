classdef ParallelHelper
    % ParallelHelper - Helper class for parallel pool
    %   This class provides a set of helper methods to provide transparent
    %   parallel behavior accross MATLAB versions. All of its methods are
    %   static.

    methods(Static)

        function open_pool()
            % Open the pool
            if(verLessThan('matlab', '8.2'))
                matlabpool('open', 'AttachedFiles', {});
            else
                parpool;
            end
            % Check for installation of Lynx
            check_install_on_cluster();
        end
        
        function close_pool()
            % Close the pool (if open)
            if(verLessThan('matlab', '8.2'))
                if(matlabpool('size') > 0)
                    matlabpool('close');
                end
            else
                if(~isempty(gcp('nocreate')))
                    delete(gcp);
                end
            end
        end
        
        function s = get_pool_size()
            % Get the pool size
            if(verLessThan('matlab', '8.2'))
                s = matlabpool('size');
            else
                p = gcp('nocreate'); % If no pool, do not create new one.
                if isempty(p)
                    s = 0;
                else
                    s = p.NumWorkers;
                end
            end
        end
        
    end
    
end

