% Free-space prapagation function using Huygens spherical convolution.
%
% g1 can be any arbitary shape, g2 is an automatically generated square
% matrix based on field information from G1.
%
% Given a certain field information at g1 plane, we can predict any field
% of view by defining x2half and dx2 (assuming the field is only polarized
% along x or y direction)
%
% Advantage: 
% Great for fine and small g1 and relatively large g2 plane matrix. Also,
% free from replica generated from Fourier Transform approach. Allow
% different sampling rate at g1 and g2 planes. Good for analyzing finely 
% sampleddata generated from FDTD software near field
% 
% Disadvantage:
% Very slow if g1 is a large matrix. Recommend size of g1 < 500x500
%
% g1:     Field information at initial plane
% dx1:    Grid size at g1 plane
% dx2:    Grid size at g2 plane
% Nx2:    Number of pixels at the target plane (assuming centered)
% z:      Propagation distance
% lambda: Wavelength used
% 
% Example: 
%
% g1=zeros(60);g1(30,30)=1;
% dx1=10e-6; dx2=1e-6; z=0.01;lambda =532e-9; x2half=1e-4;
% [g2]=ConvProp(g1,dx1,dx2,z,x2half,lambda)
%
% NOTE: x2half is the distance from the end of camera to the center subtracted
% by half pixel length
%
% eg: pixel size = 1 um & 5 pixels.
% |1|2|3|4|5|
% 
% 
%                                          ---Disi A Sep, 6th, 2013  
%                                               adis@mit.edu



function [g2]=ConvProp(g1,dx1,dx2,z,Nx2,lambda)

% storing certain constant values in the loop to increase calcualtion speed.
z_sqr=z^2;     
k=2*pi/lambda;
% g2 plane coordinate
x2half=dx2*(Nx2-1)/2;
x2=-x2half:dx2:x2half;
x1half=dx1*(length(g1)-1)/2;
x1=-x1half:dx1:x1half;
[xx1,yy1]=meshgrid(x1);
[xx2,yy2]=meshgrid(x2);

N1=numel(g1);

g2=zeros(length(x2));

h = waitbar(0,'Please wait...');
for n1=1:N1
    
    x_1=xx1(n1);y_1=yy1(n1);
    r_sqr=(xx2-x_1).^2+(yy2-y_1).^2+z_sqr;
    % r=sqrt(r_sqr);
    % Goodman - Intro to Fourier Optics Equation 3-51 ---- 4-9
    g2=g2+z/1j/lambda*g1(n1)*exp(1j*k*sqrt(r_sqr))./r_sqr*dx1^2;  
    %g2=g2+z*g1(n1)*exp(1j*k*r)./r_sqr*dx1^2;
    waitbar(n1/N1,h,sprintf('%3.1f %%',n1/N1*100))
end

close(h)
%imagesc(abs(g2))

end