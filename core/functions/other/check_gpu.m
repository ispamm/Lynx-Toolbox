function check_gpu()
%CHECK_GPU Checks whether the GPU is compatible, and eventually resets it

if(~parallel.gpu.GPUDevice.isAvailable)
    error('LearnTool:Hardware:GpuNotSupported', 'Your GPU is not supported by the Matlab Parallel Computing Toolbox, or currently not available');
else
    fprintf('Initializing GPU device...\n');
    gpuDevice(1);
end

end

