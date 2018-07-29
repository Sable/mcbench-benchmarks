%function marisaScript
% script to run over marisa
%clear all
d=load('bund1min');
alldata=d.data;
data=alldata(1:end,:);
N= 10:10:300;
M= 10:5:200;
step=30;
x=data(1:step:end,4);
SH=zeros(length(N),length(M));
SHrow=zeros(1,length(M));
tic
% loop over N,M
for i=1:length(N)
    parfor j = 1:length(M)
        SHrow(j) = sqrt(60*11/step)*marisa(x,N(i),M(j));
    end
    SH(i,:)=SHrow;
    %N(i)
end
toc
imagesc(M,N,SH); colorbar
[I,J] = find(SH==max(max(SH)));
%[sh,pnl] = sqrt(60*11/step)*marisa(x,N(I),M(J));
[sh,pnl,pos] = marisa(x,N(I),M(J));sh=sqrt(60*11/step);
figure
plot(cumsum(pnl)); grid on
title(['Sharpe = ',num2str(sh),', N=',num2str(N(I)),', M=',num2str(M(J))])
figure
surf(M,N,SH), shading interp, lighting phong, light

th=1:size(data,1);
t=th(1:step:end);
