% This program filters the given image using Gabor Filters and decomposes
% into multi resolution Transform Pyramid.
% Here E0 is the gabir Filter Set ( 4 scales and $ Orientations ) 
% You can view the Filters by typing the command
% imagesc(real(E0{i,j}));colormap(gray); axis off in the command window .  Here i=1,2,3,4 And J=1,2,3,4 represents each filter in differnet orientation and also scale
% E1 is the resultant Filtered Image Pyramid Here First row contains First
% scale images that are not downsampled
% Second row contains Images that are downsampled Once.Similarly 3rd and
% fourth rows corespondingly . Fivth row represents Low pass filtered and
% High pass Filtered and Downsampled Images.

function [E0,E1]=gaborfiltering
global E0;
nscale=4;norient=4;minWaveLength=3; mult=2;sigmaOnf=0.65;dThetaOnSigma=1.5;feedback=1;

% Filter Construction and Display 
cols=512;rows=512;
EO = cell(nscale, norient);          
[x,y] = meshgrid( [-cols/2:(cols/2-1)]/cols,...
		  [-rows/2:(rows/2-1)]/rows);
radius = sqrt(x.^2 + y.^2);                  
radius(round(rows/2+1),round(cols/2+1)) = 1;  

%calculate sine and cosine of the polar angle of all pixels about the
 %centre point					     
theta = atan2(-y,x);              
sintheta = sin(theta);
costheta = cos(theta);
clear x; clear y; clear theta;      
thetaSigma = pi/norient/dThetaOnSigma;  

% The main loop
for o = 1:norient
   if feedback
     fprintf('Processing orientation %d \r', o);
  end
    
  angl = (o-1)*pi/norient;                               
  wavelength = minWaveLength;                            
  dc = costheta * cos(angl) + sintheta * sin(angl);     
  ds = sintheta * cos(angl) - costheta * sin(angl); 
  dtheta = abs(atan2(ds,dc));                           
  spread = exp((-dtheta.^2) / (2 * thetaSigma^2));      

  for s = 1:nscale,                  % For each scale.

    
    fo = 1.0/wavelength;                  % Centre frequency of filter.

    logGabor = exp((-(log(radius/fo)).^2) / (2 * log(sigmaOnf)^2));  
    logGabor(round(rows/2+1),round(cols/2+1)) = 0; % Set the value at the center of the filter              

      E0{s,o} = (logGabor .* spread);     

    wavelength = wavelength * mult;       %  calculate Wavelength of next filter
  end                                     
end                                         % For each orientation

% ---  Filter Consstruction complete -------------

%--------- Image and its Fourier Transform---------------------
a=imread('balaji.bmp');   % Change this code according to the Input Image type 
a=rgb2gray(a);
a=im2double(a);
imagefft=fft2(a);       % Fourier Transform of Image
%---------------------------------------------------------------


% Gabor Transformed Image and Decomposition of it---------------

E1=cell(5,4);
for j=1:1:4
    E1{1,j}=ifft2(fftshift(E0{1,j}).*imagefft); % First Scale. So No downsampling in transform domain
end

n1=1;
for i=2:1:4
    for j=1:1:4
        E1{i,j}=ifft2(downsam((fftshift(E0{i,j}).*imagefft),n1)); % Downsampled And Filetered Images in Transform Domain ( Image Pyramid)
    end
    n1=n1+1;
end

E1{5,1}=ifft2(downsam(lpf1(imagefft),3));
E1{5,2}=ifft2(hpf(imagefft));

%------------------------- Image Pyramid is in E1------------------ 

%Functions for Down Sampling the Images in Fourier Domain-----------%
function r=downsam(x1,notimes)
r=x1;
for k=1:1:notimes
    r=imgshrink(r);
end

function x=imgshrink(a)
x=a;
N=size(x,1);
n=0;
for i=1:1:N
    for j=1:1:(N/2)
        z(i,j)=x(i,j+n);
       n=n+1;
    end
    n=0;
end
n=0;
for i=1:1:(N/2)
    for j=1:1:(N/2);
        z1(i,j)=z(i+n,j);
    end
   n=n+1;
end
x=z1;

% ------------------------------------------------------------------------%

% Low Pass Filter and High Pass Filter for paasing DC of Image and also very high frequency Components        
function ty=lpf1(a);
[U,V]=dftuv(size(a,1),size(a,2));
D0=0.02*size(a,1);
H=exp(-(U.^2 + V.^2)/(2*D0^2));
ty=(a.*H);

function [U,V] =dftuv(M,N)
u=0:(M-1);
v=0:(N-1);
idx=find(u>M/2);
u(idx)=u(idx)-M;
idy=find(v>N/2);
v(idy)=v(idy)-N;
[V U]=meshgrid(v,u);


function ty=hpf(a)
[U,V]=dftuv(size(a,1),size(a,2));
D0=0.3*size(a,1);
F=fft2(a);
H=exp(-(U.^2 + V.^2)/(2*D0^2));
H1=1-H;
ty=(a.*H1);


