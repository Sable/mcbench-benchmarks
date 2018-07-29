function vi = interp3_gpu(x, y, z, v, xi, yi, zi)

persistent k_interp3;

if isempty(k_interp3)
    gpu = gpuDevice;
    k_interp3 = parallel.gpu.CUDAKernel('interp3_cuda.ptx', 'interp3_cuda.cu');
    k_interp3.ThreadBlockSize = gpu.MaxThreadsPerBlock / 2; % Use only half of the max number of threads allowed. Don't know why but sometimes it just doesn't work if use more than half.
end

nPoints = numel(xi);
nBlocks = ceil(nPoints / k_interp3.ThreadBlockSize(1));
if nBlocks <= 1024 % Use no more than 1024 blocks per grid row.
    k_interp3.GridSize = nBlocks;
else
    k_interp3.GridSize = [1024 ceil(nBlocks/1024)];
end

g_vi = parallel.gpu.GPUArray.zeros(nPoints, 1, 'single');

g_nPoints = gpuArray(int32(nPoints));
g_xSize = gpuArray(int32(length(x)));
g_ySize = gpuArray(int32(length(y)));
g_zSize = gpuArray(int32(length(z)));

g_x = gpuArray(single(x));
g_y = gpuArray(single(y));
g_z = gpuArray(single(z));
g_v = gpuArray(single(v));

g_xi = gpuArray(single(xi));
g_yi = gpuArray(single(yi));
g_zi = gpuArray(single(zi));

g_vi = feval(k_interp3, ...
    g_vi, g_nPoints, g_xSize, g_ySize, g_zSize, ...
    g_x, g_y, g_z, g_v, g_xi, g_yi, g_zi);

vi = reshape(gather(g_vi), size(xi));
