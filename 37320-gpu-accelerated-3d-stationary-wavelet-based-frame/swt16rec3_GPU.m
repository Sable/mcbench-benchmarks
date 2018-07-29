function result = swt16rec3_GPU(dec_full, level, waveletName)
%SWT16rec3 Stationary wavelet-based 2-level frame in 3-D.
%   swt16rec3_GPU performs a multi-level 3-D stationary wavelet synthesis
%   using a specific waveletName.  
%
%   result = swt16rec3_GPU(dec_full, level, waveletName) computes the 
%   3-D matrix 'result' at using the coefficients in 'dec_full', level 
%   'level' and using 'waveletName'. Level must be either 1 or 2. Wavelet Toolbox
%   is required to retrieve the filters using 'waveletName'. Both 'level'
%   and 'waveletName' should match those used in creating 'dec_full'.
%
%   Requires the Parallel Computing Toolbox and a compatible GPU.
%
%   See conv3DGPU and swt16dec3_GPU

%   A. Kucukelbir 12-June-2012.
%   Last Revision: 26-June-2012.

% Create filters
if ischar(waveletName)
    [~,~,LR,HR] = wfilters(waveletName); 
end

% Define kernels to be used by GPU
rowsKernel    = parallel.gpu.CUDAKernel('conv3DGPU.ptx', 'conv3DGPU.cu', 'rowsKernel');
columnsKernel = parallel.gpu.CUDAKernel('conv3DGPU.ptx', 'conv3DGPU.cu', 'columnsKernel');
beamsKernel   = parallel.gpu.CUDAKernel('conv3DGPU.ptx', 'conv3DGPU.cu', 'beamsKernel');
halfSum       = parallel.gpu.CUDAKernel('conv3DGPU.ptx', 'conv3DGPU.cu', 'halfSum');

% Upsample filters and create temporary cell
x = cell(1,1);
for i = 1:level-1
   LR = dyadup(LR,1);
   HR = dyadup(HR,1); 
end

% Set parameters for convolution kernels on GPU
BLOCKDIM_X = 8; 
BLOCKDIM_Y = 8; 
BLOCKDIM_Z = 8; 

for i = 1:level

    % Grab first level of frame coeffieicents.
    dec = dec_full(1:8);
    dec_full(1:8) = [];
    
    % Downsample filters
    if(i==2)
        LR = dyaddown(LR,0);
        HR = dyaddown(HR,0);   
    end
    
    % Move filters to GPU
    LR_g = gpuArray(LR);
    HR_g = gpuArray(HR);

    % Calculate kernel radius
    if( mod(length(LR),2) == 0 )
        kernelRadius = length(LR)/2;
    else
        kernelRadius = (length(LR)-1)/2;
    end

    % Ensure volume has dimensions that are a multiple of 8
    diff = 0;
    if( mod(size(dec{1,1},1),8) ~= 0 )
    diff = 8*ceil(size(dec{1,1},1)/8) - size(dec{1,1},1);
        for j=1:8
        dec{j,1} = padarray(dec{j,1},[diff diff diff],'post');
        end
    end

    % Calculate volume sizes and transfer to GPU
    volRowSize = size(dec{1,1},1);
    volColSize = size(dec{1,1},2);
    volBeaSize = size(dec{1,1},3);
    dec1_g = gpuArray(dec{1,1});
    dec2_g = gpuArray(dec{2,1});
    dec3_g = gpuArray(dec{3,1});
    dec4_g = gpuArray(dec{4,1});
    dec5_g = gpuArray(dec{5,1});
    dec6_g = gpuArray(dec{6,1});
    dec7_g = gpuArray(dec{7,1});
    dec8_g = gpuArray(dec{8,1});

    % Setup GPU grids and blocks
    rowsKernel.GridSize        = [(volRowSize / BLOCKDIM_X) * (volBeaSize / BLOCKDIM_Z) , (volColSize / BLOCKDIM_Y)];
    rowsKernel.ThreadBlockSize = [BLOCKDIM_X, BLOCKDIM_Y, BLOCKDIM_Z];

    columnsKernel.GridSize        = [(volRowSize / BLOCKDIM_X) * (volBeaSize / BLOCKDIM_Z) , (volColSize / BLOCKDIM_Y)];
    columnsKernel.ThreadBlockSize = [BLOCKDIM_X, BLOCKDIM_Y, BLOCKDIM_Z];

    beamsKernel.GridSize        = [(volRowSize / BLOCKDIM_X) * (volBeaSize / BLOCKDIM_Z) , (volColSize / BLOCKDIM_Y)];
    beamsKernel.ThreadBlockSize = [BLOCKDIM_X, BLOCKDIM_Y, BLOCKDIM_Z];

    halfSum.GridSize        = [(volRowSize / BLOCKDIM_X) * (volBeaSize / BLOCKDIM_Z) , (volColSize / BLOCKDIM_Y)];
    halfSum.ThreadBlockSize = [BLOCKDIM_X, BLOCKDIM_Y, BLOCKDIM_Z];

    % Do the SWT for this level
    tmp_g = swt3_1level(dec1_g, dec2_g, dec3_g, dec4_g, dec5_g, dec6_g, dec7_g, dec8_g,...
                      LR_g, HR_g, ...
                      volRowSize, volColSize, volBeaSize, kernelRadius,...
                      rowsKernel, columnsKernel, beamsKernel, halfSum);

    % Remove multiple of 8 padding
    tmp = gather(tmp_g);
    x{i,1} = tmp(1:end-diff, 1:end-diff, 1:end-diff);

    % Remove kernelRadius padding
    if( mod(length(LR),2) == 0 )
            x{i,1} = x{i,1}(kernelRadius:end-(kernelRadius-1)-1, kernelRadius:end-(kernelRadius-1)-1, kernelRadius:end-(kernelRadius-1)-1);
    else
            x{i,1} = x{i,1}(kernelRadius+1:end-kernelRadius, kernelRadius+1:end-kernelRadius, kernelRadius+1:end-kernelRadius);
    end
           
    % Take care of second level specific processing
    if (i == 2)
        x{1,1} = padarray(x{1,1},[diff diff diff],'post');
        dec1_g = gpuArray(x{1,1});
            tmp_g = swt3_1level(dec1_g, dec2_g, dec3_g, dec4_g, dec5_g, dec6_g, dec7_g, dec8_g,...
                      LR_g, HR_g, ...
                      volRowSize, volColSize, volBeaSize, kernelRadius,...
                      rowsKernel, columnsKernel, beamsKernel, halfSum);
        tmp = gather(tmp_g);
        tmp = tmp(1:end-diff, 1:end-diff, 1:end-diff);          
        if( mod(length(LR),2) == 0 )
            x{1,1} = tmp(kernelRadius:end-(kernelRadius-1)-1, kernelRadius:end-(kernelRadius-1)-1, kernelRadius:end-(kernelRadius-1)-1);
        else
            x{1,1} = tmp(kernelRadius:end-kernelRadius-1, kernelRadius:end-kernelRadius-1, kernelRadius:end-kernelRadius-1);
        end
    end
             
end

% Combine results from all levels
result = zeros(size(x{1,1}));
for i = 1:level
    result = result + 1/level*x{i,1};
end

end

function x = swt3_1level(dec1_g, dec2_g, dec3_g, dec4_g, dec5_g, dec6_g, dec7_g, dec8_g,...
                  LR_g, HR_g, ...
                  volRowSize, volColSize, volBeaSize, kernelRadius,...
                  rowsKernel, columnsKernel, beamsKernel, halfSum)

%% FIRST PASS ALONG BEAMS
% Get the AA
aaa_Lo_Lo_Lo_g = parallel.gpu.GPUArray.zeros(volRowSize, volColSize, volBeaSize);
daa_Lo_Lo_Hi_g = parallel.gpu.GPUArray.zeros(volRowSize, volColSize, volBeaSize);
aa_Lo_Lo_g     = parallel.gpu.GPUArray.zeros(volRowSize, volColSize, volBeaSize);

aaa_Lo_Lo_Lo_g = feval( beamsKernel, aaa_Lo_Lo_Lo_g, dec1_g, LR_g, volRowSize, volColSize, volBeaSize, kernelRadius );
daa_Lo_Lo_Hi_g = feval( beamsKernel, daa_Lo_Lo_Hi_g, dec2_g, HR_g, volRowSize, volColSize, volBeaSize, kernelRadius );

aa_Lo_Lo_g = feval( halfSum, aa_Lo_Lo_g, aaa_Lo_Lo_Lo_g, daa_Lo_Lo_Hi_g, volRowSize, volColSize, volBeaSize );

% Get the DA
ada_Lo_Hi_Lo_g = parallel.gpu.GPUArray.zeros(volRowSize, volColSize, volBeaSize);
dda_Lo_Hi_Hi_g = parallel.gpu.GPUArray.zeros(volRowSize, volColSize, volBeaSize);
da_Lo_Hi_g     = parallel.gpu.GPUArray.zeros(volRowSize, volColSize, volBeaSize);

ada_Lo_Hi_Lo_g = feval( beamsKernel, ada_Lo_Hi_Lo_g, dec3_g, LR_g, volRowSize, volColSize, volBeaSize, kernelRadius );
dda_Lo_Hi_Hi_g = feval( beamsKernel, dda_Lo_Hi_Hi_g, dec4_g, HR_g, volRowSize, volColSize, volBeaSize, kernelRadius );

da_Lo_Hi_g = feval( halfSum, da_Lo_Hi_g, ada_Lo_Hi_Lo_g, dda_Lo_Hi_Hi_g, volRowSize, volColSize, volBeaSize );

% Get the AD
aad_Hi_Lo_Lo_g = parallel.gpu.GPUArray.zeros(volRowSize, volColSize, volBeaSize);
dad_Hi_Lo_Hi_g = parallel.gpu.GPUArray.zeros(volRowSize, volColSize, volBeaSize);
ad_Hi_Lo_g     = parallel.gpu.GPUArray.zeros(volRowSize, volColSize, volBeaSize);

aad_Hi_Lo_Lo_g = feval( beamsKernel, aad_Hi_Lo_Lo_g, dec5_g, LR_g, volRowSize, volColSize, volBeaSize, kernelRadius );
dad_Hi_Lo_Hi_g = feval( beamsKernel, dad_Hi_Lo_Hi_g, dec6_g, HR_g, volRowSize, volColSize, volBeaSize, kernelRadius );

ad_Hi_Lo_g = feval( halfSum, ad_Hi_Lo_g, aad_Hi_Lo_Lo_g, dad_Hi_Lo_Hi_g, volRowSize, volColSize, volBeaSize );

% Get the DD
add_Hi_Hi_Lo_g = parallel.gpu.GPUArray.zeros(volRowSize, volColSize, volBeaSize);
ddd_Hi_Hi_Hi_g = parallel.gpu.GPUArray.zeros(volRowSize, volColSize, volBeaSize);
dd_Hi_Hi_g     = parallel.gpu.GPUArray.zeros(volRowSize, volColSize, volBeaSize);

add_Hi_Hi_Lo_g = feval( beamsKernel, add_Hi_Hi_Lo_g, dec7_g, LR_g, volRowSize, volColSize, volBeaSize, kernelRadius );
ddd_Hi_Hi_Hi_g = feval( beamsKernel, ddd_Hi_Hi_Hi_g, dec8_g, HR_g, volRowSize, volColSize, volBeaSize, kernelRadius );

dd_Hi_Hi_g = feval( halfSum, dd_Hi_Hi_g, add_Hi_Hi_Lo_g, ddd_Hi_Hi_Hi_g, volRowSize, volColSize, volBeaSize );


%% SECOND PASS ALONG COLUMNS
% Get the A
aa_Lo_Lo_gt = parallel.gpu.GPUArray.zeros(volRowSize, volColSize, volBeaSize);
da_Lo_Hi_gt = parallel.gpu.GPUArray.zeros(volRowSize, volColSize, volBeaSize);
a_Lo_g      = parallel.gpu.GPUArray.zeros(volRowSize, volColSize, volBeaSize);

aa_Lo_Lo_gt = feval( columnsKernel, aa_Lo_Lo_gt, aa_Lo_Lo_g, LR_g, volRowSize, volColSize, volBeaSize, kernelRadius );
da_Lo_Hi_gt = feval( columnsKernel, da_Lo_Hi_gt, da_Lo_Hi_g, HR_g, volRowSize, volColSize, volBeaSize, kernelRadius );

a_Lo_g = feval( halfSum, a_Lo_g, aa_Lo_Lo_gt, da_Lo_Hi_gt, volRowSize, volColSize, volBeaSize );


% Get the D
ad_Hi_Lo_gt = parallel.gpu.GPUArray.zeros(volRowSize, volColSize, volBeaSize);
dd_Hi_Hi_gt = parallel.gpu.GPUArray.zeros(volRowSize, volColSize, volBeaSize);
d_Hi_g      = parallel.gpu.GPUArray.zeros(volRowSize, volColSize, volBeaSize);

ad_Hi_Lo_gt = feval( columnsKernel, ad_Hi_Lo_gt, ad_Hi_Lo_g, LR_g, volRowSize, volColSize, volBeaSize, kernelRadius );
dd_Hi_Hi_gt = feval( columnsKernel, dd_Hi_Hi_gt, dd_Hi_Hi_g, HR_g, volRowSize, volColSize, volBeaSize, kernelRadius );

d_Hi_g = feval( halfSum, d_Hi_g, ad_Hi_Lo_gt, dd_Hi_Hi_gt, volRowSize, volColSize, volBeaSize );

                       
%% FIRST PASS ALONG ROWS
a_Lo_gt = parallel.gpu.GPUArray.zeros(volRowSize, volColSize, volBeaSize);
d_Hi_gt = parallel.gpu.GPUArray.zeros(volRowSize, volColSize, volBeaSize);
x       = parallel.gpu.GPUArray.zeros(volRowSize, volColSize, volBeaSize);

a_Lo_gt = feval( rowsKernel, a_Lo_gt, a_Lo_g, LR_g, volRowSize, volColSize, volBeaSize, kernelRadius );
d_Hi_gt = feval( rowsKernel, d_Hi_gt, d_Hi_g, HR_g, volRowSize, volColSize, volBeaSize, kernelRadius );

x = feval( halfSum, x, a_Lo_gt, d_Hi_gt, volRowSize, volColSize, volBeaSize );
              
                       
end












