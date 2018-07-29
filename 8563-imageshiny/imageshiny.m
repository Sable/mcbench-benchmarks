function RGB=imageshiny(data,nsd,beta1,beta2);
% IMAGESHINY(data,nsd,beta1,beta2);
% Displays an image with a shiny appearance
% Parameters
% data      : Matrix of double
% nsd       : No. of standard deviations of the data to use when
%             thresholding eg 2
% beta1     : -1 < 1 ; 0 has no effect, positive numbers make the image
%             more red, negative makes it more blue
% beta2     : -1 < 1 ; 0 has no effect, positive numbers make the image
%             brighter, negative makes it darker

% *************************************************************
% *** GRJ Cooper September 2003
% *** cooperg@geosciences.wits.ac.za
% *** www.wits.ac.za/science/geophysics/gc.htm
% *************************************************************

% Check for bad data values

data=double(data);
dmin=min(data(:)); dmax=max(data(:)); dmean=(dmin+dmax)*0.5; 
data(isnan(data))=dmean; data(isinf(data))=dmean; % NB mean fails on NaN's

% Get gradient

[dx,dy]=gradient(data);
slope=sqrt(dx.*dx+dy.*dy); slope(isnan(slope))=0;
smin=min(slope(slope~=0)); slope(slope==0)=smin;
slope=log(slope); clear dx dy;

% Normalise

zm=mean(data(:)); zs=std(data(:)); zmax=zm+zs*nsd; zmin=zm-zs*nsd; 
data(data>zmax)=zmax; data(data<zmin)=zmin;
data=0.5+(data-zmin)*0.5/(zmax-zmin);
zm=mean(slope(:)); zs=std(slope(:)); zmax=zm+zs*nsd; zmin=zm-zs*nsd; 
slope(slope>zmax)=zmax; slope(slope<zmin)=zmin;
slope=(slope-zmin)/(zmax-zmin); slope=1-slope;

% adjust brightness 

tol=sqrt(eps);  % this code taken from the Matlab Brighten function
if beta1~=0
 if beta1>0 gamma=1-min(1-tol,beta1); else gamma=1/(1+max(-1+tol,beta1)); end;
 data=data.^gamma;
end;
if beta2~=0
 if beta2>0 gamma=1-min(1-tol,beta2); else gamma=1/(1+max(-1+tol,beta2)); end;
 slope=real(slope.^gamma);
end;

% Shiny algorithm

HSV(:,:,1)=1-data; HSV(:,:,2)=1-slope; HSV(:,:,3)=slope;
RGB=hsv2rgb(HSV); clear HSV;
figure(1); clf;
subplot(1,2,1); imagesc(data); axis equal; axis tight; axis xy; axis off; colormap(gray(256)); title('Data');
subplot(1,2,2); imshow(RGB); axis equal; axis tight; axis xy; title('Shiny Data');
figure(2); clf;
subplot(1,1,1); imshow(RGB); axis equal; axis tight; axis xy; % fullscreen plot
title('Shiny Data');

% Gratuitous 3D graphics

figure(3); clf;
surf(data,RGB); axis off; axis tight; shading flat; view(5,85);
