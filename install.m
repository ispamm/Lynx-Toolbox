% INSTALL Installation script for the toolbox. This adds all the folders to
% the Matlab search path, and searches for the presence of any required
% external libray. If a library is not present, it allows to automatically
% download it from the web and install it.

addpath(genpath(pwd));

directories = {'tmp/', 'results/', 'lib/'};
for i=1:length(directories)
    if(~exist(directories{i}, 'dir'))
        mkdir(directories{i});
    end
end

% We check for existence of libraries, and eventually install them
check_and_install_library('Deep Learn Toolbox', 'saetrain', ...
    'https://github.com/rasmusbergpalm/DeepLearnToolbox/archive/master.zip', ...
    'StackedAutoEncoder algorithm');
check_and_install_library('LibSVM', 'svmpredict', ...
    'http://www.csie.ntu.edu.tw/~cjlin/cgi-bin/libsvm.cgi?+http://www.csie.ntu.edu.tw/~cjlin/libsvm+zip', ...
    'SupportVectorMachine algorithm');
check_and_install_library('Kernel Methods Toolbox', 'km_fbkrls', ...
    'http://downloads.sourceforge.net/project/kmbox/KMBOX-0.9.zip', ...
    'KPCA preprocessor, KPCA wrapper, sparsification of KernelRecursiveLeastSquare algorithm');

fprintf('Adding toolbox to path...\n');
addpath(genpath('./lib/'));

fprintf('Installation complete\n');