%% 3-D Image Smoothing through Multivariant Kernel Regression
% A few examples of 3-d image smoothing through multivrant kernel
% regression: ksrmv. 

%% Noisy MATLAB Logo Smoothing
L = 40*membrane(1,25)+randn(51);
[x,y]=meshgrid(0:50);
r=ksrmv([x(:) y(:)],L(:));
Lr=L;
Lr(:)=r.f;
subplot(121), surf(x,y,L)
subplot(122), surf(x,y,Lr)

%% Noisy MATLAB Logo with 20% Missing Data
L = 40*membrane(1,25)+randn(51);
I = ceil(rand(510,1)*2500);
L(I)=NaN;
[x,y]=meshgrid(0:50);
r=ksrmv([x(:) y(:)],L(:));
Lr=L;
Lr(:)=r.f;
subplot(121), surf(x,y,L)
subplot(122), surf(x,y,Lr)

%% Noisy Peaks Smoothing
L = 10*peaks(50)+randn(50);
[x,y]=meshgrid(1:50);
r=ksrmv([x(:) y(:)],L(:));
Lr=L;
Lr(:)=r.f;
subplot(121), surf(x,y,L)
subplot(122), surf(x,y,Lr)

%% Noisy Peaks with 20% Missing Data
L = 10*peaks(50)+randn(50);
I = ceil(rand(500,1)*2500);
L(I) = NaN;
[x,y]=meshgrid(1:50);
r=ksrmv([x(:) y(:)],L(:));
Lr=L;
Lr(:)=r.f;
subplot(121), surf(x,y,L)
subplot(122), surf(x,y,Lr)