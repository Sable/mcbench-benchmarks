clear,clc,close all;

A=[1 1 0 0 0 0;
    1 0 1 1 1 0;
    0 1 1 1 0 1;
    1 1 1 1 0 0;
    1 1 1 0 0 1];

[m,n]=size(A);
t=2/n;  %threshold
AFreq{1,1}=GetFreq1(A,t);
AFreq{2,1}=GetFreq2(A,t,AFreq{1});

for k=3:n
    if(AFreq{k-1}==0)
        break;
    end
    AFreq{k,1}=GetFreqk(A,t,AFreq{1},AFreq{k-1});
end
