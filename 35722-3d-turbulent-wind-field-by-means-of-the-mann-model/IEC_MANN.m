function utmp = IEC_MANN(Nx,Ny,Nz,delta,UHub,HubHt,IECturbC)
%%INITIALISATION

% definition of constants
twopi=2*pi;
%constants and derived parameters from IEC
gamma = 3.9; %IEC, (B.12)
alpha = 0.2; %IEC, sect. 6.3.1.2

%set delta1 according to guidelines (chap.6)
if HubHt<=60,
    delta1=0.7*HubHt;
else
    delta1=42;
end;

%IEC, Table 1, p.22
if IECturbC == 'A',
    Iref=0.16;
elseif IECturbC == 'B',
    Iref=0.14; 
elseif IECturbC == 'C',
    Iref=0.12;
else
    error('IECturbC can be equal to A,B or C;adjust the input value')
end;

%IEC, sect. 6.3.1.3
b=5.6;
sigma1=Iref*(0.75*UHub+b);
sigma2=0.7*sigma1;
sigma3=0.5*sigma1;
%derived constants
l=0.8*delta1; %IEC, (B.12)
sigmaiso=0.55*sigma1; %IEC, (B.12)

Cij2=zeros(3,3,Nx,Ny,Nz);
ikx=cat(2,-Nx/2:-1,1:Nx/2-1);
[x y z]=ndgrid(ikx,1:Ny,1:Nz);
k1=(x)*l/(Nx*delta)*twopi;
k2=(y-Ny/2)*l/(Ny*delta)*twopi;
k3=(z-Nz/2)*l/(Nz*delta)*twopi;
kabs=sqrt(k1.^2+k2.^2+k3.^2);
beta= gamma./(kabs.^(2/3).*real(pfq([1/3 17/6],4/3,-kabs.^(-2))));
k03=k3+beta.*k1;
k0abs=sqrt(k1.^2+k2.^2+k03.^2);
Ek0=1.453*k0abs.^4./(1+k0abs.^2).^(17/6);
C1=beta.*k1.^2.*( k0abs.^2 - 2*k03.^2 + beta.*k1.*k03 )./( kabs.^2.*( k1.^2 + k2.^2 ));
C2=k2.*k0abs.^2./ (exp( (3/2).*log( k1.^2 + k2.^2 ) )) .* atan2( beta.*k1.* sqrt( k1.^2 + k2.^2 ) ,( k0abs.^2 - k03.*k1.*beta));
xhsi1=C1 - k2.*C2./k1;
xhsi2=k2.*C1./k1 + C2;
CC=sigmaiso*sqrt(twopi*pi*l^3.*Ek0./(Nx*Ny*Nz*delta^3.*k0abs.^4));
Cij2(1,1,1:size(k1,1),:,:)= CC.*( k2.*xhsi1);
Cij2(1,2,1:size(k1,1),:,:)= CC.*( k3 - k1.*xhsi1 + beta.*k1);
Cij2(1,3,1:size(k1,1),:,:)= CC.*( -k2);
Cij2(2,1,1:size(k1,1),:,:)= CC.*( k2.*xhsi2 - k3 - beta.*k1);
Cij2(2,2,1:size(k1,1),:,:)= CC.*( -k1.*xhsi2);
Cij2(2,3,1:size(k1,1),:,:)= CC.*( k1);
Cij2(3,1,1:size(k1,1),:,:)= CC.*( k0abs.^2.*k2 ./ (kabs.^2));
Cij2(3,2,1:size(k1,1),:,:)= CC.*( -k0abs.^2.*k1 ./ (kabs.^2));
%Cij2(isnan(Cij2))=0;
%% FOURIER COEFFICIENTS
n=complex(normrnd(0,1,[3 1 Nx Ny Nz]),normrnd(0,1,[3 1 Nx Ny Nz]));
H = reshape(mtimesx(Cij2,n,'speed'),[],Nx,Ny,Nz);
%% TIME SERIES
u(1,:,:,:)=real(fftn(fftshift(H(1,:,:,:))));
u(2,:,:,:)=real(fftn(fftshift(H(2,:,:,:))));
u(3,:,:,:)=real(fftn(fftshift(H(3,:,:,:))));

stdDv=zeros(Ny*Nz,3);
stdDv(:,1)=reshape(std(u(1,:,:,:)),Ny*Nz,1); % Standard deviation for u-component
stdDv(:,2)=reshape(std(u(2,:,:,:)),Ny*Nz,1); % Standard deviation for v-component
stdDv(:,3)=reshape(std(u(3,:,:,:)),Ny*Nz,1); % Standard deviation for w-component

% Introduction of a Corrective Factor SF in order to adjust the statistics
% as advised by the OC4 project DTUs report

sf=zeros(Ny*Nz,3);
sf(:,1)=sqrt(sigma1^2./(stdDv(:,1).^2));
sf(:,2)=sqrt((sigma2)^2./(stdDv(:,2).^2));
sf(:,3)=sqrt((sigma3)^2./(stdDv(:,3).^2));

utmp=zeros(3,Nx,Ny,Nz);
for i=1:length(sf),
    for j=1:Ny,
        for k=1:Nz,            
            utmp(1,:,j,k)=sf(i,1).*u(1,:,j,k);
            utmp(2,:,j,k)=sf(i,2).*u(2,:,j,k);
            utmp(3,:,j,k)=sf(i,3).*u(3,:,j,k);
        end;
    end;
end;
for i=1:Nz,
    thisZ=HubHt-(Nz*delta)/2+1.*i*(Nz*delta)/(Nz-1);
    profile=UHub*(thisZ/HubHt)^alpha;
    utmp(1,:,:,i)=(utmp(1,:,:,i)+profile);    
end;


