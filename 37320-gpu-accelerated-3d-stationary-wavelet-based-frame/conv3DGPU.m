% Check if CUDA code has been compiled
%   NOTE: Make sure to check your Visual Studio path if compilation fails on
%   Windows!
%   NOTE: Only tested on TESLA C2070 
if (exist('conv3DGPU.ptx','file') ~= 2)
    if (ispc)
        [status, result] = system('"C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat" & nvcc -ptx conv3DGPU.cu','-echo');
    else
        [status, result] = system('nvcc -ptx conv3DGPU.cu','-echo');
    end
end
