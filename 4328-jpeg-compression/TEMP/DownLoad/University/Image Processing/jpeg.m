function jpeg

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%      THIS WORK IS SUBMITTED BY:
%%
%%      OHAD GAL
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;

% ==================
% section 1.2 + 1.3
% ==================
% the following use of the function:    
%
%    plot_bases( base_size,resolution,plot_type )
%
% will plot the 64 wanted bases. I will use "zero-padding" for increased resolution
% NOTE THAT THESE ARE THE SAME BASES !
% for reference I plot the following 3 graphs:
% a) 3D plot with basic resolution (64 plots of 8x8 pixels) using "surf" function
% b) 3D plot with x20 resolution (64 plots of 160x160 pixels) using "mesh" function
% c) 2D plot with x10 resolution (64 plots of 80x80 pixels) using "mesh" function
% d) 2D plot with x10 resolution (64 plots of 80x80 pixels) using "imshow" function
%
% NOTE: matrix size of pictures (b),(c) and (d), can support higher frequency = higher bases
%       but I am not asked to draw these (higher bases) in this section !
%       the zero padding is used ONLY for resolution increase !
%
% get all base pictures (3D surface figure)
plot_bases( 8,1,'surf3d' );

% get all base pictures (3D surface figure), x20 resolution
plot_bases( 8,20,'mesh3d' );

% get all base pictures (2D mesh figure), x10 resolution
plot_bases( 8,10,'mesh2d' );   

% get all base pictures (2D mesh figure), x10 resolution
plot_bases( 8,10,'gray2d' );   



% ==================
% section 1.4 + 1.5
% ==================
% for each picture {'0'..'9'} perform a 2 dimensional dct on 8x8 blocks.
% save the dct inside a cell of the size: 10 cells of 128x128 matrix
% show for each picture, it's dct 8x8 block transform.

for idx = 0:9
   
   % load a picture
   switch idx
   case {0,1}, input_image_128x128 = im2double( imread( sprintf( '%d.tif',idx ),'tiff' ) );
   otherwise, input_image_128x128 = im2double( imread( sprintf( '%d.tif',idx),'jpeg' ) );
   end   
   
   % perform DCT in 2 dimension over blocks of 8x8 in the given picture
   dct_8x8_image_of_128x128{idx+1} = image_8x8_block_dct( input_image_128x128 );

   if (mod(idx,2)==0)
      figure;
   end     
   subplot(2,2,mod(idx,2)*2+1);
   imshow(input_image_128x128);
   title( sprintf('image #%d',idx) );
   subplot(2,2,mod(idx,2)*2+2);
   imshow(dct_8x8_image_of_128x128{idx+1});
   title( sprintf('8x8 DCT of image #%d',idx) );
end



% ==================
% section 1.6
% ==================
% do statistics on the cell array of the dct transforms
% create a matrix of 8x8 that will describe the value of each "dct-base" 
% over the transform of the 10 given pictures. since some of the values are
% negative, and we are interested in the energy of the coefficients, we will
% add the abs()^2 values into the matrix.
% this is consistent with the definition of the "Parseval relation" in Fourier Coefficients

% initialize the "average" matrix 
mean_matrix_8x8 = zeros( 8,8 );

% loop over all the pictures
for idx = 1:10
    
    % in each picture loop over 8x8 elements (128x128 = 256 * 8x8 elements)
   for m = 0:15
      for n = 0:15
         mean_matrix_8x8 = mean_matrix_8x8 + ...
            abs( dct_8x8_image_of_128x128{idx}(m*8+[1:8],n*8+[1:8]) ).^2;
      end
   end
end

% transpose the matrix since the order of the matrix is elements along the columns,
% while in the subplot function the order is of elements along the rows
mean_matrix_8x8_transposed = mean_matrix_8x8';

% make the mean matrix (8x8) into a vector (64x1)
mean_vector = mean_matrix_8x8_transposed(:);

% sort the vector (from small to big)
[sorted_mean_vector,original_indices] = sort( mean_vector );

% reverse order (from big to small)
sorted_mean_vector = sorted_mean_vector(end:-1:1);
original_indices = original_indices(end:-1:1);

% plot the corresponding matrix as asked in section 1.6
figure;
for idx = 1:64
   subplot(8,8,original_indices(idx));
   axis off;
   h = text(0,0,sprintf('%4d',idx));
   set(h,'FontWeight','bold');
   text(0,0,sprintf(' \n_{%1.1fdb}',20*log10(sorted_mean_vector(idx)) ));
end

% add a title to the figure
subplot(8,8,4);
h = title( 'Power of DCT coefficients (section 1.6)' );
set( h,'FontWeight','bold' );



% ==================
% section 1.8
% ==================
% picture 8 is chosen
% In this section I will calculate the SNR of a compressed image againts
% the level of compression. the SNR calculation is defined in the header 
% of the function:  <<calc_snr>> which is given below.
%
% if we decide to take 10 coefficients with the most energy, we will add
% zeros to the other coefficients and remain with a vector 64 elements long
% (or a matrix of 8x8)

% load the original image
original_image = im2double( imread( '8.tif','jpeg' ) );

% I will use this matrix to choose only the wanted number of coefficients
% the matrix is initialized to zeros -> don't choose any coefficient at all
coef_selection_matrix = zeros(8,8);

% compressed picture set (to show the degrading)
compressed_set = [1 3 5 10 15 20 30 40];

% this loop will choose each time, the "next-most-energetic" coefficient, 
% to be added to the compressed image -> and thus to improove the SNR
for number_of_coefficient = 1:64
    
    % find the most energetic coefficient from the mean_matrix
    [y,x] = find(mean_matrix_8x8==max(max(mean_matrix_8x8)));
    
    % select if for the compressed image
    coef_selection_matrix(y,x) = 1;
    
    % replicate the selection matrix for all the parts of the dct transform
    % (remember that the DCT transform creates a set of 8x8 matrices, where
    %  in each matrix I need to choose the coefficients defined by the 
    %  <<coef_selection_matrix>> matrix )
    selection_matrix = repmat( coef_selection_matrix,16,16 );
    
    % set it as zero in the mean_matrix, so that in the next loop, we will
    % choose the "next-most-energetic" coefficient
    mean_matrix_8x8(y,x) = 0;
    
    % choose the most energetic coefficients from the original image
    % (total of <<number_of_coefficient>> coefficients for this run in the loop)
    compressed_image = image_8x8_block_dct(original_image) .* selection_matrix;
    
    % restore the compressed image from the given set of coeficients
    restored_image = image_8x8_block_inv_dct( compressed_image );
    
    % calculate the snr of this image (based on the original image)
    SNR(number_of_coefficient) = calc_snr( original_image,restored_image );
    
    if ~isempty(find(number_of_coefficient==compressed_set))
        if (number_of_coefficient==1)
            figure;
            subplot(3,3,1);
            imshow( original_image );
            title( 'original image' );
        end
        subplot(3,3,find(number_of_coefficient==compressed_set)+1);
        imshow( restored_image );
        title( sprintf('restored image with %d coeffs',number_of_coefficient) );
    end
end

% plot the SNR graph
figure;
plot( [1:64],20*log10(SNR) );
xlabel( 'numer of coefficients taken for compression' );
ylabel( 'SNR [db] ( 20*log10(.) )' );
title( 'SNR graph for picture number 8, section 1.8' );
grid on;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% --------------------------------------------------------------------------------
%%         I N N E R   F U N C T I O N   I M P L E M E N T A T I O N
%% --------------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ---------------------------------------------------------------------------------
% pdip_dct2 - implementation of a 2 Dimensional DCT
%
% assumption: input matrix is a square matrix !
% ---------------------------------------------------------------------------------
function out = pdip_dct2( in )

% get input matrix size
N = size(in,1);

% build the matrix
n = 0:N-1;
for k = 0:N-1
   if (k>0)
      C(k+1,n+1) = cos(pi*(2*n+1)*k/2/N)/sqrt(N)*sqrt(2);
   else
      C(k+1,n+1) = cos(pi*(2*n+1)*k/2/N)/sqrt(N);
   end   
end

out = C*in*(C');

% ---------------------------------------------------------------------------------
% pdip_inv_dct2 - implementation of an inverse 2 Dimensional DCT
%
% assumption: input matrix is a square matrix !
% ---------------------------------------------------------------------------------
function out = pdip_inv_dct2( in )

% get input matrix size
N = size(in,1);

% build the matrix
n = 0:N-1;
for k = 0:N-1
   if (k>0)
      C(k+1,n+1) = cos(pi*(2*n+1)*k/2/N)/sqrt(N)*sqrt(2);
   else
      C(k+1,n+1) = cos(pi*(2*n+1)*k/2/N)/sqrt(N);
   end   
end

out = (C')*in*C;

% ---------------------------------------------------------------------------------
% plot_bases - use the inverse DCT in 2 dimensions to plot the base pictures
%
% Note: we can get resolution be zero pading of the input matrix !!!
%       that is by calling: in = zeros(base_size*resolution)
%       where:  resolution is an integer > 1
%       So I will use zero pading for resolution (same as in the fourier theory)
%       instead of linear interpolation.
% ---------------------------------------------------------------------------------
function plot_bases( base_size,resolution,plot_type )

figure;
for k = 1:base_size
   for l = 1:base_size
      in = zeros(base_size*resolution);
      in(k,l) = 1;							% "ask" for the "base-harmonic (k,l)"
      subplot( base_size,base_size,(k-1)*base_size+l );
      switch lower(plot_type)
      case 'surf3d', surf( pdip_inv_dct2( in ) );
      case 'mesh3d', mesh( pdip_inv_dct2( in ) );
      case 'mesh2d', mesh( pdip_inv_dct2( in ) ); view(0,90);
      case 'gray2d', imshow( 256*pdip_inv_dct2( in ) );         
      end     
      axis off;
   end
end

% add a title to the figure
subplot(base_size,base_size,round(base_size/2));
h = title( 'Bases of the DCT transform (section 1.3)' );
set( h,'FontWeight','bold' );

% ---------------------------------------------------------------------------------
% image_8x8_block_dct - perform a block DCT for an image
% ---------------------------------------------------------------------------------
function transform_image = image_8x8_block_dct( input_image )

transform_image = zeros( size( input_image,1 ),size( input_image,2 ) );
for m = 0:15
    for n = 0:15
        transform_image( m*8+[1:8],n*8+[1:8] ) = ...
            pdip_dct2( input_image( m*8+[1:8],n*8+[1:8] ) );
    end
end


% ---------------------------------------------------------------------------------
% image_8x8_block_inv_dct - perform a block inverse DCT for an image
% ---------------------------------------------------------------------------------
function restored_image = image_8x8_block_inv_dct( transform_image )

restored_image = zeros( size( transform_image,1 ),size( transform_image,2 ) );
for m = 0:15
    for n = 0:15
        restored_image( m*8+[1:8],n*8+[1:8] ) = ...
            pdip_inv_dct2( transform_image( m*8+[1:8],n*8+[1:8] ) );
    end
end


% ---------------------------------------------------------------------------------
% calc_snr - calculates the snr of a figure being compressed
%
% assumption: SNR calculation is done in the following manner:
%             the deviation from the original image is considered 
%             to be the noise therefore:
%
%                   noise = original_image - compressed_image
%
%             the SNR is defined as:  
%
%                   SNR = energy_of_image/energy_of_noise
%
%             which yields: 
%
%                   SNR = energy_of_image/((original_image-compressed_image)^2)
% ---------------------------------------------------------------------------------
function SNR = calc_snr( original_image,noisy_image )

original_image_energy = sum( original_image(:).^2 );
noise_energy = sum( (original_image(:)-noisy_image(:)).^2 );
SNR = original_image_energy/noise_energy;
