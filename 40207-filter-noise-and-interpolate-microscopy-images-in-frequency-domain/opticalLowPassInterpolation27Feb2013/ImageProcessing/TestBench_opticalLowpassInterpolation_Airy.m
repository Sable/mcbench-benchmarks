%% Generate an Airy Pattern and add noise.
N=65;
xrange=[-1 1];
x=linspace(xrange(1),xrange(2),N);
[xx, yy]=meshgrid(x);
[theta, rr]=cart2pol(xx,yy);
AiryPattern=jinc(rr).^2;
AiryPattern=uint16((2^10-1)*AiryPattern);
NoisyPattern=imnoise(AiryPattern,'poisson');

%% Filter and Interpolate.
xs=x(2)-x(1);
fcut=2; % The Fourier transform of the Airy Pattern (chinese hat) cuts-off at 2 in frequency domain.
%gaussorder=500;
AiryFiltI1=opticalLowpassInterpolation(AiryPattern,xs,fcut,1);
AiryFiltI2=opticalLowpassInterpolation(AiryPattern,xs,fcut,2);
AiryFiltI3=opticalLowpassInterpolation(AiryPattern,xs,fcut,3);
NoisyFiltI1=opticalLowpassInterpolation(NoisyPattern,xs,fcut,1);
NoisyFiltI2=opticalLowpassInterpolation(NoisyPattern,xs,fcut,2);
NoisyFiltI3=opticalLowpassInterpolation(NoisyPattern,xs,fcut,3);
figure(1); clf; colormap jet;
set(1,'defaultaxesfontsize',16);
imagecat(x,x,AiryPattern,AiryFiltI1,AiryFiltI2,AiryFiltI3,NoisyPattern,NoisyFiltI1,NoisyFiltI2,NoisyFiltI3,'link','equal');

%% Compare line profiles along X.

% Function handles to extract the midprofile and generate xaxis.
xprof=@(img) img(floor(0.5*size(img,1))+1,:);
xaxis=@(img,xrange) linspace(xrange(1),xrange(2),size(img,2));

% Profiles from airy pattern.
AiryProfiles=cellfun(@(img) xprof(img),...
    {AiryPattern,AiryFiltI1,AiryFiltI2,AiryFiltI3},...
    'UniformOutput',false);
AiryAxis=cellfun(@(img) xaxis(img,xrange),...
    {AiryPattern,AiryFiltI1,AiryFiltI2,AiryFiltI3},...
    'UniformOutput',false);

% Profiles from noisy pattern.
NoisyProfiles=cellfun(@(img) xprof(img),...
    {NoisyPattern,NoisyFiltI1,NoisyFiltI2,NoisyFiltI3},...
    'UniformOutput',false);
NoisyAxis=cellfun(@(img) xaxis(img,xrange),...
    {NoisyPattern,NoisyFiltI1,NoisyFiltI2,NoisyFiltI3},...
    'UniformOutput',false);


figure(2); clf; set(2,'defaultaxesfontsize',16);
plot(AiryAxis{1},AiryProfiles{1},AiryAxis{2},AiryProfiles{2},...
    AiryAxis{3},AiryProfiles{3},AiryAxis{4},AiryProfiles{4},...
    'LineWidth',2);
legend('Airy','AiryFiltInterpolation1','AiryFiltInterpolation2','AiryFiltInterpolation3');

snapnow;

figure(3); clf; set(3,'defaultaxesfontsize',16);
plot(NoisyAxis{1},NoisyProfiles{1},NoisyAxis{2},NoisyProfiles{2},...
    NoisyAxis{3},NoisyProfiles{3},NoisyAxis{4},NoisyProfiles{4},...
    'LineWidth',2);
legend('Noisy','NoisyFiltInterpolation1','NoisyFiltInterpolation2','NoisyFiltInterpolation3');
snapnow;