function [Pctr] = nrfrac(xrngl,xrngr,yrngb,yrngu,res,n)
%Renders the areas of convergence of the Newton-Raphson
%method for root finding, applied to equation z^3-1=0
%in the complex plane .
%[xrngl,xrngr]- "x" boundaries
%[yrngb,yrngu]- "y" boundaries
%res - "resolution". Warning! Don`t try very small values.
%n - number of iterations
%this function returns "Pctr"-image matrix. Don`t forget to type ";"
%===By Valery Garmider , 04/04/03

%Determines the area boundaries
xRange=[xrngl:res:xrngr];
yRange=[yrngb:res:yrngu];
yRange=rot90(yRange);
%size of the area
width=length(xRange);
height=length(yRange);
%helper variables
Ix=ones(1,width);
Iy=ones(height,1);
%matrix of initial points for Newton-Raphson method
Z=Iy*xRange + i*yRange*Ix;
%the main loop
for k=1:n
   Z = Z -(Z.^3-1)./(3*Z.^2);
end;
%omit singular points
Sd=~isfinite(Z);
[I,J]=find(Sd);
Z(I,J)=0;
%matrices of convergence
MfR=abs(Z-1);
MfG=abs(Z-exp(2*pi*i/3));
MfB=abs(Z-exp(4*pi*i/3));
%render parameter
Blur=0.05;
%color matrices
RenderR=Blur./(Blur+MfR);
RenderG=Blur./(Blur+MfG);
RenderB=Blur./(Blur+MfB);
%==you may also try this :
%Bndr=0.01;
%Blur=0.1;
%MaskR=(MfR<=Bndr);
%RenderR=(Bndr^Blur-MfR.^Blur).*MaskR/(Bndr^Blur);
%MaskG=(MfG<=Bndr);
%RenderG=(Bndr^Blur-MfG.^Blur).*MaskG/(Bndr^Blur);
%MaskB=(MfB<=Bndr);
%RenderB=(Bndr^Blur-MfB.^Blur).*MaskB/(Bndr^Blur);
%==render matrix
Pctr(:,:,1)=RenderR;
Pctr(:,:,2)=RenderG;
Pctr(:,:,3)=RenderB;

figure( ...
   'numbertitle','off', ...
   'name','Newton-Raphson Pathology', ...
   'color','k', ...
   'menubar','none', ...
   'position',[50 50 width height]);

Ax=axes( ...
   'position',[0.0 0.0 1.0 1.0]);

image(Pctr);

set(Ax,'box','off','xtick',[],'ytick',[]);




