function  F = FGG_2d_type1(f,knots,N,accuracy,GridListx, GridListy)
%Description:
%This code implements the "accelerated" Gaussian-gridding-based NUFFT
%described in Greengard and Lee [1]. The gridding approach is very similar
%to previous work by Nguyen and Liu [2]; the only difference is the use of
%a different convolution kernel ([1] claims that the Gaussian kernel has
%computational advantages). Both algorithms allow the user to specify the
%numerical precision of the routine, but [1] provides a nice summary that
%would allow one to tabulate the appropriate variable values for each
%desired numerical precision. Code for [2] is also available upon request.
%
%This code performs NUFFTs for rectangular cubes of size
%N=[Nx,Ny] (not counting frequency padding for image interpolation). The
%approximate DFT attains errors on the order of 1e-6 (for more accuracy,
%increase the parameter M_sp). 
%
%Inputs:
%       f: frequency-domain data (a complex Mx1 vector) unwrapped from a
%           matrix knots: k-space locations at which the data were measured
%           (an Mx2 vector). This data must be in double format.
%       knots: the frequency locations of the data points. These locations
%           should be normalized to correspond to the grid boundaries
%           [-N/2, N/2 -1/N], N even. If the knots are not scaled
%           properly, they will be shifted and scaled into this normalized
%           form.
%       N = [Nx,Ny]: the 1x2 vector denoting the size of the spatial
%           grid in the image domain. This parameter will determine the
%           spatial extent of the image.
%       accuracy: (optional input parameter) a positive integer indicating 
%           the desired number of digits of accuracy  
%Optional Inputs (highly recommended):
%       GridListx:(column vector) The x-locations of the frequency grid 
%           (not yet scaled by c or 2*pi) onto which the data should be 
%           interpolated
%       GridListy:(column vector) The y-locations of the frequency grid 
%           (not yet scaled by c or 2*pi) onto which the data should be 
%           interpolated
%Outputs:
%       F: the 2D NUFFT (approximate DFT) of f, with dimension [Nx, Ny].
%
%
%Usage Notes:
%In order for this function to work, the C
%file "FGG_Convolution2D.c" must be compiled into a Matlab executable 
%(cmex) with the following command in the command prompt:
%
%mex FGG_Convolution2D.c
%
%A note on the effect of M_sp on the algorithm's accuracy:
%[R,M_sp]=[2,3]  ==> 1e-3 accuracy
%[R,M_sp]=[2,6]  ==> single precision
%[R,M_sp]=[2,9]  ==> 1e-9 accuracy
%[R,M_sp]=[2,12] ==> double precision
%
%References:
%[1] L. Greengard and J. Lee, "Accelerating the Nonuniform Fast Fourier
%Transform," SIAM Review, Vol. 46, No. 3, pp. 443-454.
%[2] N. Nguyen and Q. H. Liu, "Nonuniform fast fourier transforms," SIAM J.
%Sci. Comput., 1999.
%
%
%Please note:
%This code is free to use, but we ask that you please reference the source,
%as this will encourage future funding for more free AFRL products. This
%code was developed through the AFOSR Lab Task "Moving-Target Radar Feature
%Extraction."
%Project Manager: Arje Nachman
%Principal Investigator: Matthew Ferrara
%Date: November 2008
%
%Code by (send correspondence to):
%Matthew Ferrara, Research Mathematician
%AFRL Sensors Directorate Innovative Algorithms Branch (AFRL/RYAT)
%Matthew.Ferrara@wpafb.af.mil

%Explanation of variables used
%bw             The bandwidth of the input data (fmax-fmin)
%dgx,dgy        The separation (in the frequency domain) of the
%               user-defined k-space grid onto which the data should be 
%               interpolated
%E1, E2, E3     factors of the Gaussian filter in the frequency domain
%               (the Gaussian is factored to eliminate redundant
%               exponential calculations)
%E4             The Gaussian deconvolution filter
%f              The Mx1 vector of nonuniformly-spaced frequency data given
%               as input to the NUFFT routine
%f_tau          The [R*Nx,R*Ny] matrix of uniformly-spaced fequency-domain
%               data values after "gridding"
%F_tau          The FFT of f_tau
%F              The approximate DFT of f (the deconvolved FFT of f_tau)
%fmean          The average knot values of the input data (1x2 vector)   
%j              Index variable that indexes the convolution loop through
%               the data points (1 <= j <= M)
%kmin           The minimum knot values of the input data (1x2 vector)
%kmax           The maximum knot values of the input data (1x2 vector)
%knots          The Mx1 vector of frequency locations given as input to
%               the NUFFT. 
%M              The number of (k-space) data points (the length of the
%               input data vector f)
%M_sp           Width of the frequency-domain box used in the approximate
%               interpolation of each data point onto the frequency grid
%               (M_sp=6 for single precision and M_sp=12 for double
%               precision)
%N              The image size of the NUFFT output (N=[Nx, Ny])
%Nx             The length of the image in the x dimension
%Ny             The length of the image in the y dimension
%R              Oversampling ratio for gridding in the frequency (data)
%               domain
%scale          1x2 vector used to scale the input data locations into the
%               normalized form
%shift          1x2 vector used to shift the input data locations into the
%               normalized form
%tau            The 2x1 Gaussian kernel spreading factor
%End Explanation of variables

%% Step 1: Initialize constant variables:
M=length(f);%number of frequency-domain data points
if nargin<4, accuracy=6; end
if nargin<3, N=M; accuracy=6; end
if length(N)<2, N=N(1)*[1,1];accuracy=6; end
%The size parameters [Nx,Ny] determine the spatial extent of the image
Nx=N(1); Ny=N(2);
%R is the oversampling ratio(>1) for gridding in the frequency (data)
%domain. There are diminishing returns in accuracy after R=2 (M_sp has a
%more direct effect on accuracy).
R=2;
%M_sp is the length of the convolution kernel
M_sp=accuracy;%This gives roughly 6 digits of accuracy
%The variance, tau, of the Gaussian filter may be different in each
%dimension
%tau = M_sp./(N.^2);%I was initially using this value
tau = (pi*M_sp./(N.*N*R*(R-.5)));%Suggested value of tau by Greengard [1]
%The length of the oversampled grid
M_r = R*N;
%Scale knots (data locations) to [-N/2,N/2-1] (I don't initially use 
%Greengard's [0,2*pi] convention, but instead assume users will most likely 
%be thinking in terms of fs<=f<=fe)
kmin=min(knots);
kmax=max(knots);
if nargin <=4,%Simply choose the most convenient frequency-domain grid
    bw=kmax-kmin;
    scale=(N-1)./bw;
    shift=-N/2-kmin.*scale;
    knots=repmat(scale,[M,1]).*knots + repmat(shift,[M,1]);
else %we specify knot locations in terms of the user-defined grid (this
    %consequently specifies the image pixel locations)
    fmean=(kmin+kmax)/2;
    dgx=GridListx(2)-GridListx(1);
    dgy=GridListy(2)-GridListy(1);
    kminx=fmean(1)-(Nx/2)*dgx;
    kmaxx=kminx+(Nx-1)*dgx;
    kminy=fmean(2)-(Ny/2)*dgy;
    kmaxy=kminy+(Ny-1)*dgy; 
    kmin=[kminx,  kminy];
    kmax=[kmaxx,  kmaxy];
    %The BW that covers the whole k-space region when confined to the
    %specified grid spacing
    bw=[kmaxx-kminx,  kmaxy-kminy];
    scale=(N-1)./bw;
    shift=-.5*[Nx,Ny]-[kminx,kminy].*scale;
    knots=repmat(scale,[M,1]).*knots + repmat(shift,[M,1]);
end
%save k-space locations of the interpolated data:
%kspace_locsx=
%Switch knot locations to [0,2*pi] convention (used by Greengard):
knots=mod(2*pi*knots./repmat(N,[M,1]),2*pi);%Makes NUFFT implementation 
%more straightforward when notation is the same!

%Precompute E_3, the constant component of the (truncated) Gaussian:
E_3x(1,1:M_sp) = exp(-((pi*(1:M_sp)/M_r(1)).^2)/tau(1));
%don't waste (slow) exponential calculations
E_3x=[fliplr(E_3x(1:(M_sp-1))),1,E_3x];
E_3y(1,1:M_sp) = exp(-((pi*(1:M_sp)/M_r(2)).^2)/tau(2));
%don't waste (slow) exponential calculations
E_3y=[fliplr(E_3y(1:(M_sp-1))),1,E_3y];
%Precompute E_4 (for devonvolution after the FFT)
kx_vec = (-Nx/2):(Nx/2-1);
%The Hadamard Inverse of the Fourier Transform of the truncated Gaussian
E_4x(1:Nx,1)=sqrt(pi/tau(1))*exp(tau(1)*(kx_vec.^2));
ky_vec = (-Ny/2):(Ny/2-1);
%The Hadamard Inverse of the Fourier Transform of the truncated Gaussian
E_4y(1,1:Ny)=sqrt(pi/tau(2))*exp(tau(2)*(ky_vec.^2));%
%End initialization of constant variables

%% Step 2: Approximate convolution for each datum location, (x_j,y_j). This
% step is implemented in C and compiled into a Matlab-executable (cmex)
% file.
%Initialize convolved data matrix
f_tau=zeros(M_r(1),M_r(2));
f_taui=zeros(M_r(1)*M_r(2),1);%Imaginary components of f_tau
f_taur=zeros(M_r(1)*M_r(2),1);%Real components of f_tau
%Perform convolution onto finely-spaced grid
%keyboard
[f_taur,f_taui]=...
    FGG_Convolution2D(double(real(f(:))),double(imag(f(:))),...
    double(knots(:)),E_3x,E_3y,[M_sp, tau(1), tau(2), M_r(1), M_r(2)]);
f_tau = reshape(f_taur+sqrt(-1)*f_taui,[M_r(1), M_r(2)]);


%% Step 3: Perform FFT and deconvolve the result
%Perform FFT
F_tau=fftshift(fftn(fftshift(f_tau)));
%Chop off excess pixels(the fine spacing in the frequency domain expanded
%the image in the transform domain)
F_tau(1:round(.5*(R-1)*Nx),:)=[];
F_tau(Nx+1:end,:)=[];
F_tau(:,1:round(.5*(R-1)*Ny))=[];
F_tau(:,Ny+1:end)=[];

%Deconvolve the FFT
F=F_tau.*(E_4x*E_4y)/(M*R*R); %Note that the scaling factor is 1/M, which is 
%apparently not 1/M_r as shown in eqn (9) in [1]. This makes sense because
%the scaling factor for the DFT we are attempting to approximate (in eqn 
%(1) of [1]) is 1/M. 


%figure
%imagesc(abs(fftshift(fftn(fftshift(F)))))
%title('Interpolated k-space data: may be a rotated version of actualt data...this is due to the "optimal fitting"')


%% If desired, compare to DFT 
% F_true=zeros(Nx,Ny);
% for m=(-Nx/2):(Nx/2 -1)
%     for n=(-Ny/2):(Ny/2 -1)
%         for k=1:M
%             F_true(m+Nx/2+1,n+Ny/2+1)=F_true(m+Nx/2+1,n+Ny/2+1)+...
%                 f(k)*exp(sqrt(-1)*(m*knots(k,1) + n*knots(k,2)));
%         end
%     end
% end
% F_true=F_true/M;
% 
% figure
% imagesc(abs(F))
% title('F via NUFFT')
% colorbar
% 
% figure
% imagesc(abs(F_true))
% title('F via DFT')
% colorbar
% 
% figure
% imagesc(abs(F-F_true))
% title('Error between NUFFT and DFT')
% colorbar
%error('done!')
