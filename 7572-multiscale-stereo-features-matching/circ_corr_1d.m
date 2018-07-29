function corrmap=circ_corr_1d(t1,t2)

%% 1D NORMALIZED CORRELATION 

%% Input
%% t1,t2       : templates to be matched

%% Output
%% corrmap     : correlation map



% Initialization

[Nyt,Nxt]=size(t1);
Ny=Nyt;
Nx=2*Nxt-1;

t1_app=[t1, zeros(Nyt,Nxt-1)];
t1_app_square=[abs(t1).^2, zeros(Nyt,Nxt-1)]; 

t2_app=[t2, zeros(Nyt,Nxt-1)];
t2_app_square=[abs(t2).^2, zeros(Nyt,Nxt-1)];

win=[ones(Nyt,Nxt), zeros(Nyt,Nxt-1)];


%Matching

% Overlapping area
max_area=Nyt*Nxt;
v1=linspace(1,1/Nxt,Nxt);
v1=[v1,flipdim(v1(2:Nxt),2)];
area=max_area*v1;

%num
num1=ifft(  fft(t1_app,[],2).*conj(fft(t2_app,[],2)) ,[],2 );
num1=sum(num1,1);
num2=ifft(  fft(t1_app,[],2).*conj(fft(win,[],2)) ,[],2  );
num2=sum(num2,1);
num3=ifft(  fft(win,[],2).*conj(fft(t2_app,[],2))  ,[],2 );
num3=sum(num3,1);
num=num1-(num2.*num3)./area;
  
%den
den1=ifft(  fft(t1_app_square,[],2).*conj(fft(win,[],2)) ,[],2 );
den1=sum(den1,1);
den2=ifft(  fft(t1_app,[],2).*conj(fft(win,[],2))  ,[],2  );
den2=sum(den2,1);
den_1=sqrt(  den1 -  (den2.* conj(den2)./area)   );
den3=ifft(  fft(win,[],2).*conj(fft(t2_app_square,[],2)) ,[],2  );
den3=sum(den3,1);
den4=ifft(  fft(win,[],2).*conj(fft(t2_app,[],2)) ,[],2  );
den4=sum(den4,1);
den_2=sqrt(  den3 -  (den4.* conj(den4)./area)   );

weight=sqrt(v1);
  
den=(den_1.*den_2);
den=den.*(den~=0)+100*(den==0);  
corrmap=real(weight.*num./den);
  
corrmap=circshift(corrmap,Nxt-1);
  