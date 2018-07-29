function fractfield=gen_UMF2d(alpha,C1,H,dim);
% function fractfield=UMF2d([alpha,C1,H,dim]);
%
% Generation of a stocastic 2D multi-fractal random field
% Can be used to simulate DEM, turbulent fields (clouds etc)
%
% Based on:
% Lovejoy - Schertzer "Nonlinear variability in geophysics: multifractal
% simulations and analysis"
% 
% Inputs:
% alpha = [0..2] Levy parameter, governs the mutli-fractal behvoiur 
%    (0 = monofractals)
% C1 = governs the sparseness of the field
% H = fractional integration, parameters, governs the ruggedness
% or smoothness of the field
% dim = size of the fractal field

%   Author(s): Andrea Monti Guarnieri, P. Biancardi, , D. D'Aria et. al

% Example - syntehsis of a likely Digital Elevation Model
% H=1.9; dem=gen_UMF2d(1.8, 0.05, H, 150); 
% colormap('bone'); surfl(dem); shading('interp')
% H governs the ruggedness

if nargin == 0
 alpha=1.8; C1=0.05; H=1.2; dim=200;
end

d=2;
 
alphap=alpha/(alpha-1);

% Generate Levy distrbuted noise
noise=Salpha(alpha,dim,dim);
noise=2.3*(C1/(alpha-1))^(1/alpha)*noise;

% Noise transformation
NOISE=fft2(noise);
asse=assefr(1,dim)*2*pi;
[kx ky]=meshgrid(asse);

% Compute the "ultiscaling behaviour" filter
FILTER=fftshift(abs(kx+i*ky).^(-d/alphap));
FILTER(1,1)=0;

% Lowpass filter
FILTER2=lambdafilt2d(dim,dim/2,.1);

% Generate the field
noise=real(ifft2(NOISE.*FILTER.*FILTER2));
noisetemp=noise-(C1/(alpha-1)*log(dim*dim));
noisetemp=exp(noisetemp);
field=noisetemp;
FIELD=fft2(field);

% Filter
asse=assefr(1,dim)*2*pi;
[kx ky]=meshgrid(asse);
FILTER=fftshift(abs(kx+i*ky).^(-H));
FILTER(1,1)=dim^(H);%/8;
fractfield=real(ifft2(FIELD.*FILTER));



function x=Salpha(alpha,dim1,dim2)
% function x=Salpha(alpha,dim1,dim2)
% 
% Generation of a white noise with Levy pdf (parameter alpha)  
% rand('state',3);

phi0=-pi/2*(1-abs(1-alpha))/alpha;

% phi uniform in -pi/2 pi/2
phi=rand(dim1,dim2)*pi-pi/2;

% W as an exponential, averge is 1
a=rand(dim1,dim2);
W=-log(1-a);
x=(sin(alpha*(phi-phi0))./(cos(phi)).^(1/alpha).*...
     ((cos(phi-alpha*(phi-phi0))./W).^((1-alpha)/alpha)));


function  fi = assefr (Fs,n)
if rem(n,2)==0   
   fi=((0:n-1)-n/2)*Fs/n;      %n even   
else
      fi=((0:n-1)-(n-1)/2)*Fs/n;  %n odd   
end
return

function filtro=lambdafilt2d(dim,raggio,tau);
%
% Compute a low-pass filter 
% unitary on a circle 'raggio'
% and exponential decay outside with time constant tau

% crea un asse delle frequenze(dim pari o dispari)
f=assefr(1,dim)*dim;
[x,y]=meshgrid(f);

filtro=zeros(dim);
filtro=sqrt(x.^2+y.^2);

bool=(filtro>raggio);
filtro=-((filtro-raggio).*bool);
     
filtro=exp(tau*filtro);
filtro=ifftshift(filtro);

