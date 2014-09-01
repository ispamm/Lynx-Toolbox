% GPUSupport - Enable GPU support
%   This feature check that the GPU is supported. If this is verified,
%   before every experiment, if the algorithm admits GPU acceleration,
%   the dataset is transfered on the GPU.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef GPUSupport < AdditionalFeature
    
    properties
        seed;
    end
    
    methods
        
        function executeAfterInitialization(obj)
            % Check that the GPU is available, then initialize it
            if(~parallel.gpu.GPUDevice.isAvailable)
                error('Lynx:Hardware:GpuNotSupported', 'Your GPU is not supported by the Matlab Parallel Computing Toolbox, or currently not available');
            else
                fprintf('Initializing GPU device...\n');
                gpuDevice(1);
            end
        end
        
        function [a, d] = executeBeforeEachExperiment(obj, a, d)
            % Transfer the dataset on the GPU
            if(a.hasGPUSupport())
                d.X = gpuArray(d.X);
                d.Y = gpuArray(d.Y);
            end
        end
        
        function [a, d] = executeAfterEachExperiment(obj, a, d)
            % Gather the dataset
            if(a.hasGPUSupport())
                d.X = gather(d.X);
                d.Y = gather(d.Y);
            end
        end
        
        function s = getDescription(~)
            s = 'Enable GPU support';
        end
    end
    
end

