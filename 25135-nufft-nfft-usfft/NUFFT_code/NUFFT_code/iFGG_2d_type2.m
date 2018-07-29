function  f = iFGG_2d_type2(F,knots,accuracy)
%Description:
%This code implements the "accelerated" Gaussian-gridding-based inverse 
%type-II (uniform --> nonuniform) NUFFT described in Greengard and Lee [1]. 
%The gridding approach is very similar to previous work by Nguyen and Liu 
%[2]; the only difference is the use of a different convolution kernel ([1] 
%claims that the Gaussian kernel has computational advantages). Both 
%algorithms allow the user to specify the numerical precision of the 
%routine, but [1] provides a nice summary that would allow one to tabulate 
%the appropriate variable values for each desired numerical precision. Code 
%for [2] is also available upon request.
%
%This code performs NUFFTs for rectangular cubes of size
%N=[Nx,Ny] (not counting frequency padding for image interpolation). The
%approximate DFT attains errors on the order of 1e-6 (for more accuracy,
%increase the parameter M_sp). 
%
%Inputs:
%       F: the 2D matrix of time-domain data, with dimension [Nx, Ny].
%       knots: the frequency locations where we wish to compute the DFT. 
%           These locations should be normalized to correspond to the grid 
%           boundaries [-N/2, N/2 -1/N], N even. If the knots are not 
%           scaled properly, they will be shifted and scaled into this 
%           normalized form.
%       N = [Nx,Ny]: the 1x2 vector denoting the size of the spatial
%           grid in the image domain. This parameter will determine the
%           spatial extent of the image.
%Optional Inputs:
%       accuracy: a positive integer indicating the desired number of 
%           digits of accuracy   
%Outputs:
%       f: frequency-domain image (a complex Mx1 vector) unwrapped from a
%          matrix of knots: k-space locations at which the data should be
%          projected (an Mx2 vector). 

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
%E1, E2, E3     factors of the Gaussian filter in the frequency domain
%               (the Gaussian is factored to eliminate redundant
%               exponential calculations)
%E4             The Gaussian deconvolution filter
%f              The Mx1 vector of nonuniformly-spaced frequency data given
%               as input to the NUFFT routine
%f_tau          The [R*Nx,R*Ny] matrix of uniformly-spaced fequency-domain
%               data values after "gridding"
%F_tau          The "deconvolved" data matrix (=F.*filter)
%F              The equispaced data
%fmin           The minimum frequencies of the input data 
%j              Index variable that indexes the convolution loop through
%               the data points (1 <= j <= M)
%knots          The Mx1 vector of frequency locations given as input to
%               the NUFFT. 
%kmin           The minimum knot values of the input data (1x2 vector)
%kmax           The maximum knot values of the input data (1x2 vector) 
%M              The number of (k-space) data points (the length of the
%               input data vector f)
%M_sp           Width of the frequency-domain box used in the approximate
%               interpolation of each data point onto the frequency grid
%               (M_sp=6 for single precision and M_sp=12 for double
%               precision)
%N              The image size of the NUFFT output (N=[Nx, Ny])
%padF           A zero-padded version of F
%Nx             The length of the image in the x dimension
%Ny             The length of the image in the y dimension
%R              Oversampling ratio for gridding in the frequency (data)
%               domain
%scale          1x3 vector used to scale the input data locations into the
%               normalized form
%shift          1x3 vector used to shift the input data locations into the
%               normalized form
%tau            The 2x1 Gaussian kernel spreading factor
%End Explanation of variables

[Nx,Ny]=size(F);
N=[Nx,Ny]
M=size(knots,1);
%Ensure that the knots fit in a 2*pi interval
kmin=min(knots);
kmax=max(knots);
bw=kmax-kmin;
scale=(N-1)./bw;
shift=-N/2-kmin.*scale;
knots=repmat(scale,[M,1]).*knots + repmat(shift,[M,1]);
knots=mod(2*pi*knots./repmat(N,[M,1]),2*pi);%shift to [0,2*pi)

%Type-II NUFFT:
if nargin<3, accuracy=6; end
R=2;
%M_sp is the length of the convolution kernel
M_sp=accuracy;%This gives roughly 6 digits of accuracy
%The variance, tau, of the Gaussian filter may be different in each
%dimension
%tau = M_sp./(N.^2);%I was initially using this value
tau = (pi*M_sp./(N.*N*R*(R-.5)));%Suggested value of tau by Greengard [1]
%The length of the oversampled grid
M_r = R*N;
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
%Deconvolve the FFT
F=F.*(E_4x*E_4y)/M;
F=[zeros(.5*(R-1)*Nx,Ny);F;zeros(.5*(R-1)*Nx,Ny)];
F=[zeros(R*Nx,.5*(R-1)*Ny),F,zeros(R*Nx,.5*(R-1)*Ny)];%Zero pad for convolution on finer mesh in frequency domain
f_tau = fftshift(ifftn(ifftshift(F)));
f=zeros(M,1); f_r=f; f_i=f;
[f_r,f_i]=...
    FGG_Convolution2D_type2(double(real(f_tau(:))),double(imag(f_tau(:))),...
    double(knots),E_3x,E_3y,[M_sp, tau(1), tau(2), M_r(1), M_r(2)]);
f = f_r+sqrt(-1)*f_i;

%% If desired, compare to DFT 
%Type 1
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
%Type 2
%Slow way to evaluate the nonuniform DFT:
% f_dft=zeros(M,1);
% for k=1:M
%     for m=(-Nx/2):(Nx/2 -1)
%         for n=(-Ny/2):(Ny/2 -1)
%         f_dft(k)=f_dft(k)+F(m+Nx/2+1,n+Ny/2+1)*exp(-sqrt(-1)*(m*knots(k,1) + n*knots(k,2)));
%         end
%     end
% end
% f_dft=f_dft/M;
% % 
% % norm(f-f_dft)
% figure
% imagesc(abs(reshape(f_dft,[16,16])))
% colorbar
% title('DFT data')
% % pause
% % figure
% % imagesc(abs(fftshift(fftn(fftshift(reshape(f_dft,[16,16]))))))
% % colorbar
% % title('DFT image')
% figure
% imagesc(abs(reshape(f,[16,16])))
% colorbar
% title('NUFFT data')
% figure
% imagesc(abs(fftshift(fftn(fftshift(reshape(f,[16,16]))))))
% colorbar
% title('NUFFT image')
% figure
% plot(1:256,abs(f),1:256,abs(f_dft),'r')
% legend('NUFFT','DFT')
% error('Same?')
%error('done!')
