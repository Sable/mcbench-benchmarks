function corrmap=circ_corr_2d(t1,t2)

%% 2D NORMALIZED CORRELATION  

%% Input
%% t1,t2       : templates to be matched

%% Output
%% corrmap     : correlation map




%% INITIALIZATION 

[Nyt,Nxt]=size(t1);
Ny=2*Nyt-1;
Nx=2*Nxt-1;

t1_app=zeros(Ny,Nx);
t1_app_square=zeros(Ny,Nx);
t1_app(1:Nyt,1:Nxt)=t1;
t1_app_square(1:Nyt,1:Nxt)=abs(t1).^2; %abs(t1_app.*conj(t1_app));

t2_app=zeros(Ny,Nx);
t2_app_square=zeros(Ny,Nx);
t2_app(1:Nyt,1:Nxt)=t2;
t2_app_square(1:Nyt,1:Nxt)=abs(t2).^2; %abs(t2_app.*conj(t2_app))

win=zeros(Ny,Nx);
win(1:Nyt,1:Nxt)=1;

 

%overlapping area
max_area=Nyt*Nxt;
v1=linspace(1,1/Nyt,Nyt)';
v1=[v1 ; flipdim(v1(2:Nyt),1) ];
s1=repmat(v1,[1,Nx]);
v2=linspace(1,1/Nxt,Nxt);
v2=[v2,flipdim(v2(2:Nxt),2)];
s2=repmat(v2,[Ny,1]);
area=max_area*s1.*s2;

%num
num1=ifft2(  fft2(t1_app).*conj(fft2(t2_app))      );
num2=ifft2(  fft2(t1_app).*conj(fft2(win))      );
num3=ifft2(  fft2(win).*conj(fft2(t2_app))      );
num=num1-(num2.*num3)./area;
  
%den
den1=ifft2(  fft2(t1_app_square).*conj(fft2(win))      );
den2=ifft2(  fft2(t1_app).*conj(fft2(win))      );
den_1=sqrt(  den1 -  (den2.* conj(den2)./area)   );
den3=ifft2(  fft2(win).*conj(fft2(t2_app_square))      );
den4=ifft2(  fft2(win).*conj(fft2(t2_app))      );
den_2=sqrt(  den3 -  (den4.* conj(den4)./area)   );

weight=sqrt(area/max_area);
  
den=(den_1.*den_2);
den=den.*(den~=0)+100*(den==0);  
corrmap=real( (weight.*num)./den );
  
corrmap=circshift(corrmap,[Nyt-1,Nxt-1]);
  
  
