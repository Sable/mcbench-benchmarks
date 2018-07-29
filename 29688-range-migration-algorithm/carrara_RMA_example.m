%%
%An example to RMA from the book: Carrara:"Spotlight Synthetic Aperture
%Radar: Signal Processing Algortithms" Artech House 1995.
%Signal Data from: Tab10_1
%%
clear all,close all; clc
Nf=2^10; %number of points for freq. range

%array parameter
dx=0.6;L=760.8; %interelement space in synthetic array (length L)
Na=L/dx+1; %number of array elements
X=linspace(-L/2,L/2,Na).'; %position of array elements
Kx=linspace(-pi/dx,pi/dx,Na).';%azimuthal spacial wavenumber (page 410)
Kx=repmat(Kx,1,Nf);
Rs=1000; %distance from origin to the array plane
X=X+1j*Rs; % XY antenna position as complex number. Here, image processing
%in XY plane only, therefore, complex description for cartesian coordinates
%is convinient.

%frequency range
co=299792458; %free space wave velocity
fc=242.4*1E6; %last frequency in the Band of width B (in the book it should
%be center freq., but the Range Freq. in Fig. 10.11 doesn't fit then.)
B=133.5*1E6; %bandwidth
freq=linspace(fc-B,fc,Nf);
Kr=4*pi*freq/co;%Frequency wavenumber (page 410)
Kr=repmat(Kr,Na,1);

%target position:
tar=[-200+1j*100, 200+1j*100, 0+1j*100,...
    -200, 0, 200,...
    -200-1j*100, 200-1j*100, 0-1j*100]; %3x3 grid
%tar=[0, 200, -1j*100]; %(table 10.1)

%simulated data, dechirped (compressed) and deskewed in range:
data=my_sinthSISO_planresp( X,freq,tar );
%phase reference acc. to image origin
%(see also: Sanchez "3-D Radar Imaging Using Range Migration Techniques",
%IEEE; or:
%http://www.lluisvives.com/servlet/SirveObras/01604307547816095212257/003402_12.pdf):
data=data.*exp(1j*Rs*Kr);
% 
%fig10.7 and 10.8
data_compr=fftshift(ifft(data,[],2),2);
imagesc(abs(data_compr));
%fig10.7

%azimuth fft
data=fftshift(data,1); %due to -Xmin..Xmax
data=fft(data,[],1);%azimuth fft
data=fftshift(data,1); %due to -Kx_min..Kx_max
%azimuth fft

%Kx accord to fig10.11 
plot(Kx,Kr,'.')
Xax=-5:1:5;Yax=5:1:10;
axis([ min(Xax) max(Xax) min(Yax) max(Yax)])
set(gca,'XTick',Xax,'YTick',Yax)
grid on
%Kx accord to fig10.11

%fig10.11
imagesc(Kr(1,:),Kx(:,1),abs(data))
%fig10.11

%range compressed signal in Fig10.12
data_compr=fftshift(ifft(data,[],2),2);
%fig10.12
imagesc(abs(data_compr));
%fig10.12

%Ky wavenumber, squared, accordingly to (10.9) 
Ky_sq=Kr.^2-Kx.^2;
%only positive Ky is physical
Neg=logical(Ky_sq < 0); %
Ky_sq(Neg)=NaN; data(Neg)=NaN; Kr(Neg)=NaN; %only positive Ky is acceptable
%matched filter, phase acc. to (10.8)
Fmf=-Rs*Kr+Rs*sqrt(Ky_sq);
%figure 10.13
mesh(Kr,Kx,Fmf)
axis([4 10 -2.8 2.8 -2000 0])
%figure 10.13

data=data.*exp(1j*Fmf); %data matching by matched filter
%fig. 10.14 middle
data_compr=fftshift(ifft(data,[],2),2);
imagesc(abs(data_compr));
%fig. 10.14 middle

%stolt interpolation
%Fig 10.15 (a)
plot(Kx,Kr,'.')
%Fig 10.15 (a)
Ky=sqrt(Ky_sq); %cross-range wavenumber by (10.9)
%Fig 10.15 (b)
plot(Kx,Ky,'.')
%Fig 10.15 (b)
Ky_int=Ky(Na/2-0.5,:);%data interpolation to Ky_int cross-range wavenumber 
data=my_spline(Ky,data,Ky_int);%1D data interpolation by spline function
%stolt interpolation

%processing window in Ky dimension
Ny=750;
data=data(:,1:Ny);
Ky_int=Ky_int(1:Ny);

%range compression
data=fftshift(ifft(data,[],2),2);
%fig10.20 (a)
imagesc(abs(data));
%fig10.20 (a)

%azimuth compression
data=fftshift(data,1);%compare to azimuth fft above
data=ifft(data,[],1);
data=fftshift(data,1);
%%
dy=2*pi/(Ky_int(end)-Ky_int(1)); %step in cross-range dimension
Y=-Ny/2*dy:dy:(Ny/2-1)*dy;%cross-range axis
%fig10.20 (b)
imagesc(Y,X,abs(data));
ylabel('Cross-Range, m')
xlabel('Range, m')
axis([ -300 300 -300 300])
colormap('pink')
%fig10.20 (b)