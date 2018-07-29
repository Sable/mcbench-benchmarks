function wt = swt16dec3_GPU(x, level, waveletName)
%SWT16dec3 Stationary wavelet-based 2-level frame in 3-D.
%   swt16dec3_GPU performs a multi-level 3-D stationary wavelet analysis
%   using a specific waveletName.  
%
%   wt = swt16dec3_GPU(x, level, waveletName) computes the frame
%   coefficients for the 3-D matrix x at level 'level' and using
%   'waveletName'. Level must be either 1 or 2. Wavelet Toolbox
%   is required to retrieve the filters using 'waveletName'.
%
%   Requires the Parallel Computing Toolbox and a compatible GPU.
%
%   See conv3DGPU and swt16rec3_GPU

%   A. Kucukelbir 12-June-2012.
%   Last Revision: 26-June-2012.

% Create filters
if ischar(waveletName)
    [LD,HD,~,~] = wfilters(waveletName); 
end

% Define kernels to be used by GPU
rowsKernel    = parallel.gpu.CUDAKernel('conv3DGPU.ptx', 'conv3DGPU.cu', 'rowsKernel');
columnsKernel = parallel.gpu.CUDAKernel('conv3DGPU.ptx', 'conv3DGPU.cu', 'columnsKernel');
beamsKernel   = parallel.gpu.CUDAKernel('conv3DGPU.ptx', 'conv3DGPU.cu', 'beamsKernel');

% Set parameters for convolution kernels on GPU
BLOCKDIM_X = 8; 
BLOCKDIM_Y = 8; 
BLOCKDIM_Z = 8; 

for i = 1:level

    % Upsample filters
    if (i==2)
        LD = dyadup(LD,1);
        HD = dyadup(HD,1);   
    end
    
    % Move filters to GPU
    LD_g = gpuArray(LD);
    HD_g = gpuArray(HD);

    % Calculate kernel radius and pad volume
    if( mod(length(LD),2) == 0 )
        kernelRadius = length(LD)/2;
        x = padarray(x,[kernelRadius kernelRadius kernelRadius],'pre');
        x = padarray(x,[kernelRadius-1 kernelRadius-1 kernelRadius-1],'post');
    else
        kernelRadius = (length(LD)-1)/2;
        x = padarray(x,[kernelRadius kernelRadius kernelRadius],'both');
    end

    % Ensure volume has dimensions that are a multiple of 8
    diff = 0;
    if( mod(size(x,1),8) ~= 0 )
        diff = 8*ceil(size(x,1)/8) - size(x,1);
        x = padarray(x,[diff diff diff],'post');
    end
    
    % Calculate volume sizes and transfer to GPU
    volRowSize = size(x,1);
    volColSize = size(x,2);
    volBeaSize = size(x,3);
    x_g = gpuArray(x(:));

    % Setup GPU grids and blocks
    rowsKernel.GridSize        = [(volRowSize / BLOCKDIM_X) * (volBeaSize / BLOCKDIM_Z) , (volColSize / BLOCKDIM_Y)];
    rowsKernel.ThreadBlockSize = [BLOCKDIM_X, BLOCKDIM_Y, BLOCKDIM_Z];

    columnsKernel.GridSize        = [(volRowSize / BLOCKDIM_X) * (volBeaSize / BLOCKDIM_Z) , (volColSize / BLOCKDIM_Y)];
    columnsKernel.ThreadBlockSize = [BLOCKDIM_X, BLOCKDIM_Y, BLOCKDIM_Z];

    beamsKernel.GridSize        = [(volRowSize / BLOCKDIM_X) * (volBeaSize / BLOCKDIM_Z) , (volColSize / BLOCKDIM_Y)];
    beamsKernel.ThreadBlockSize = [BLOCKDIM_X, BLOCKDIM_Y, BLOCKDIM_Z];

    % Do the SWT for this level
    dec = swt3_1level(x_g, LD_g, HD_g, ...
                      volRowSize, volColSize, volBeaSize, kernelRadius,...
                      rowsKernel, columnsKernel, beamsKernel);
                  
    % Remove multiple of 8 padding
    if (diff ~= 0)
        for j=1:8
            dec{j,1} = dec{j,1}(1:end-diff, 1:end-diff, 1:end-diff);
        end
    end

    % Use the AAA volume for the next level
    x = dec{1,1};

        % Return coefficients
        if (i==2)
            wt = vertcat(dec,wt);
        else
            wt = dec;
        end          

    end

end

function dec = swt3_1level(x_g, LD_g, HD_g, ...
                           volRowSize, volColSize, volBeaSize, kernelRadius,...
                           rowsKernel, columnsKernel, beamsKernel)

%% FIRST PASS ALONG ROWS
a_Lo_g = parallel.gpu.GPUArray.zeros(size(x_g));
d_Hi_g = parallel.gpu.GPUArray.zeros(size(x_g));

% Rows Convolution
a_Lo_g = feval( rowsKernel, a_Lo_g, x_g, LD_g, volRowSize, volColSize, volBeaSize, kernelRadius );
d_Hi_g = feval( rowsKernel, d_Hi_g, x_g, HD_g, volRowSize, volColSize, volBeaSize, kernelRadius );
% end call

%% SECOND PASS ALONG COLUMNS
aa_Lo_Lo_g = parallel.gpu.GPUArray.zeros(size(a_Lo_g));
da_Lo_Hi_g = parallel.gpu.GPUArray.zeros(size(a_Lo_g));
ad_Hi_Lo_g = parallel.gpu.GPUArray.zeros(size(d_Hi_g));
dd_Hi_Hi_g = parallel.gpu.GPUArray.zeros(size(d_Hi_g));

% Columns Convolution
aa_Lo_Lo_g = feval( columnsKernel, aa_Lo_Lo_g, a_Lo_g, LD_g, volRowSize, volColSize, volBeaSize, kernelRadius );
da_Lo_Hi_g = feval( columnsKernel, da_Lo_Hi_g, a_Lo_g, HD_g, volRowSize, volColSize, volBeaSize, kernelRadius );
ad_Hi_Lo_g = feval( columnsKernel, ad_Hi_Lo_g, d_Hi_g, LD_g, volRowSize, volColSize, volBeaSize, kernelRadius );
dd_Hi_Hi_g = feval( columnsKernel, dd_Hi_Hi_g, d_Hi_g, HD_g, volRowSize, volColSize, volBeaSize, kernelRadius );
% end call

%% THIRD PASS ALONG BEAMS
aaa_Lo_Lo_Lo_g = parallel.gpu.GPUArray.zeros(size(aa_Lo_Lo_g));
daa_Lo_Lo_Hi_g = parallel.gpu.GPUArray.zeros(size(aa_Lo_Lo_g));
ada_Lo_Hi_Lo_g = parallel.gpu.GPUArray.zeros(size(da_Lo_Hi_g));
dda_Lo_Hi_Hi_g = parallel.gpu.GPUArray.zeros(size(da_Lo_Hi_g));
aad_Hi_Lo_Lo_g = parallel.gpu.GPUArray.zeros(size(ad_Hi_Lo_g));
dad_Hi_Lo_Hi_g = parallel.gpu.GPUArray.zeros(size(ad_Hi_Lo_g));
add_Hi_Hi_Lo_g = parallel.gpu.GPUArray.zeros(size(dd_Hi_Hi_g));
ddd_Hi_Hi_Hi_g = parallel.gpu.GPUArray.zeros(size(dd_Hi_Hi_g));

% Beams Convolution
aaa_Lo_Lo_Lo_g = feval( beamsKernel, aaa_Lo_Lo_Lo_g, aa_Lo_Lo_g, LD_g, volRowSize, volColSize, volBeaSize, kernelRadius );
daa_Lo_Lo_Hi_g = feval( beamsKernel, daa_Lo_Lo_Hi_g, aa_Lo_Lo_g, HD_g, volRowSize, volColSize, volBeaSize, kernelRadius );
ada_Lo_Hi_Lo_g = feval( beamsKernel, ada_Lo_Hi_Lo_g, da_Lo_Hi_g, LD_g, volRowSize, volColSize, volBeaSize, kernelRadius );
dda_Lo_Hi_Hi_g = feval( beamsKernel, dda_Lo_Hi_Hi_g, da_Lo_Hi_g, HD_g, volRowSize, volColSize, volBeaSize, kernelRadius );
aad_Hi_Lo_Lo_g = feval( beamsKernel, aad_Hi_Lo_Lo_g, ad_Hi_Lo_g, LD_g, volRowSize, volColSize, volBeaSize, kernelRadius );
dad_Hi_Lo_Hi_g = feval( beamsKernel, dad_Hi_Lo_Hi_g, ad_Hi_Lo_g, HD_g, volRowSize, volColSize, volBeaSize, kernelRadius );
add_Hi_Hi_Lo_g = feval( beamsKernel, add_Hi_Hi_Lo_g, dd_Hi_Hi_g, LD_g, volRowSize, volColSize, volBeaSize, kernelRadius );
ddd_Hi_Hi_Hi_g = feval( beamsKernel, ddd_Hi_Hi_Hi_g, dd_Hi_Hi_g, HD_g, volRowSize, volColSize, volBeaSize, kernelRadius );
% end call

%% RETURN COEFS
dec{1,1} = reshape(gather(aaa_Lo_Lo_Lo_g), volRowSize, volColSize, volBeaSize);
dec{2,1} = reshape(gather(daa_Lo_Lo_Hi_g), volRowSize, volColSize, volBeaSize);
dec{3,1} = reshape(gather(ada_Lo_Hi_Lo_g), volRowSize, volColSize, volBeaSize);
dec{4,1} = reshape(gather(dda_Lo_Hi_Hi_g), volRowSize, volColSize, volBeaSize);
dec{5,1} = reshape(gather(aad_Hi_Lo_Lo_g), volRowSize, volColSize, volBeaSize);
dec{6,1} = reshape(gather(dad_Hi_Lo_Hi_g), volRowSize, volColSize, volBeaSize);
dec{7,1} = reshape(gather(add_Hi_Hi_Lo_g), volRowSize, volColSize, volBeaSize);
dec{8,1} = reshape(gather(ddd_Hi_Hi_Hi_g), volRowSize, volColSize, volBeaSize);                       
                       
end












