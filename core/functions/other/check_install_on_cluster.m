function check_install_on_cluster()
% check_install_on_cluster - Check installation on cluster
%   This function checks that (i) Lynx is installed on all machines on the
%   cluster and (ii) that versions are all equal. Otherwise, an error is
%   thrown. By default, Matlab is installed on the desktop.

poolsize = ParallelHelper.get_pool_size();

% Inspect installation
fprintf('Checking all workers have Lynx installed...\n');
installed = zeros(poolsize, 1);
hosts = cell(poolsize, 1);
parfor ii = 1:poolsize
    installed(ii) = exist('BinaryRelevanceFactory', 'file') == 2;
    currWork = getCurrentWorker();
    hosts{ii} = currWork.Host;
end

% Compute hosts with no installation
hostsToInstall = {};
for ii = 1:poolsize
    if(~installed(ii))
        hostsToInstall{end + 1} = hosts{ii};
    end
end
hostsToInstall = unique(hostsToInstall);

if(~isempty(hostsToInstall))
    fprintf('Please ensure that Lynx is installed on the following hosts:\n');
    for ii = 1:length(hostsToInstall)
        fprintf('\t%s\n', hostsToInstall{ii});
    end
    error('Lynx:Cluster:Installation', 'Lynx missing on one or more hosts');
end

% Check versions
fprintf('Checking all workers have same version...\n');
versions = cell(poolsize, 1);
parfor ii = 1:poolsize
    versions{ii} = XmlConfiguration.readConfigValue('version');
end
[uniqueHosts, idx] = unique(hosts);
versions = versions(idx);
uniqueVersions = unique(versions);

if(length(uniqueVersions) > 1)
    fprintf('Multiple versions found on the cluster:\n');
    for ii = 1:length(uniqueHosts)
        fprintf('\t * Version %s on host %s\n', versions{ii}, hosts{ii});
    end
    error('Lynx:Cluster:Versioning', 'Multiple versions found on the cluster');
end

end

