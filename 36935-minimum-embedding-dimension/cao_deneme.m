function [E1 E2] = cao_deneme(x,tao,mmax)
%x : time series
%tao : time delay
%mmax : maximum embedding dimension
%reference:Cao, L. (1997), ``Practical method for determining the minimum
%embedding dimension of a scalar time series'', Physcai D, 110, pp. 43-50. 
%author:"Merve Kizilkaya"
N=length(x);
for m=1:mmax
    M=N-m*tao;
    Y=psr_deneme(x,m,tao,M);
    for n=1:M
        y0=ones(M,1)*Y(n,:);
        distance=max(abs(Y-y0),[],2);
        [neardis nearpos]=sort(distance);
        
        newpoint=[Y(n,:) x(n+m*tao)];
        newneig=[Y(nearpos(2),:) x(nearpos(2)+m*tao)];
        R1=max(abs(newpoint-newneig),[],2);
        
        a(n)=R1/neardis(2);
        d(n)=abs(x(n+m*tao)-x(nearpos(2)+m*tao));
    end
    E(m)=sum(a)/M;
    Ey(m)=sum(d)/M;
end
figure
E1=E(2:end)./E(1:end-1);
E2=Ey(2:end)./Ey(1:end-1);
plot(1:length(E1),E1,'k')
hold on
plot(1:length(E2),E2)
grid on
title('embedding dimension with cao method')
legend('E1','E2',4);

function Y=psr_deneme(x,m,tao,npoint)
%Phase space reconstruction
%x : time series 
%m : embedding dimension
%tao : time delay
%npoint : total number of reconstructed vectors
%Y : M x m matrix
% author:"Merve Kizilkaya"
N=length(x);
if nargin == 4
    M=npoint;
else
    M=N-(m-1)*tao;
end

Y=zeros(M,m); 

for i=1:m
    Y(:,i)=x((1:M)+(i-1)*tao)';
end



