function mask = poly2mask_gpu(x, y, m, n)

persistent k_poly2mask;

if isempty(k_poly2mask)
    gpu = gpuDevice;
    k_poly2mask = parallel.gpu.CUDAKernel('poly2mask_cuda.ptx', 'poly2mask_cuda.cu');
    k_poly2mask.ThreadBlockSize = gpu.MaxThreadsPerBlock / 2; % Use only half of the max number of threads allowed. Don't know why but sometimes it just doesn't work if use more than half.
end

if x(end) ~= x(1) || y(end) ~= y(1) % Close the polygon if it isn't closed yet.
    x(end+1) = x(1);
    y(end+1) = y(1);
end

nMaskPoints = m * n;

nBlocks = ceil(nMaskPoints / k_poly2mask.ThreadBlockSize(1));
if nBlocks <= 1024 % Use no more than 1024 blocks per grid row.
    k_poly2mask.GridSize = nBlocks;
else
    k_poly2mask.GridSize = [1024 ceil(nBlocks/1024)];
end

g_mask = parallel.gpu.GPUArray.zeros(m, n, 'int32');
g_nMaskPoints = gpuArray(int32(nMaskPoints));
g_nPolygonEdges = gpuArray(int32(length(x) - 1));
g_x = gpuArray(single(x));
g_y = gpuArray(single(y));
g_m = gpuArray(int32(m));

g_mask = feval(k_poly2mask, ...
    g_mask, g_nMaskPoints, g_nPolygonEdges, ...
    g_x, g_y, g_m);

mask = logical(gather(g_mask));
