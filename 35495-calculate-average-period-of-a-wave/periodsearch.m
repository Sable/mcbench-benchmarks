function [delta,m]=periodsearch(P, s, f)
% [delta,m]=periodsearch(P,s,f)
%
% function for  finding periods between maxinums and minimums along the
% profile/wave signal. Single or multiple profiles can be used as input for
% calculating distribution of periods.
%
% P - profiles
% s - windows for Svitsky-Golay smoothing pof rofiles, use 1 if no
% smoothing is required, 11 works well
% if f=1, histogram will be displayed
% if f=0, no plot will be displayed
% 
% delta - all periods found
% m - mean period
% 
%  created by K.Artyushkova
%  February 2012

%% subtracting the average background from all profiles
[p,q]=size(P);
L=P(:,1);
for i=1:q
    m(i)=mean(P(:,i));
    l(:,i)=m(i)*ones(size(L));
    Pc(:,i)=P(:,i)-l(:,i);
end
P=Pc;

%% smoothing profiles
for i=1:q
    P(:,i) = savgol(P(:,i)',s, 2 ,0);
end

%% searchng for minimums and maximums
delta=[];
for j=1:q
a=P(:,j);
I=[];
K=[];

for i=2:p-1
    if a(i)> a(i-1)
        if a(i)>a(i+1)
            I=[I i];
        end
    end
end
 for i=2:p-2
    if a(i+1)<a(i)
        if a(i+1)<a(i+2)
            K=[K i];
        end
    end
end
[n1,m1]=size(I); 
[n2,m2]=size(K);

for i=1:m1-1
    deltaI(i)=I(i+1)-I(i);
end
for i=1:m2-1
    deltaK(i)=K(i+1)-K(i);
end    
deltaT=[deltaI deltaK];
delta=[delta deltaT];
end

%% displaying histogram
T=round(delta);
m=mean(delta);
[N,X]=hist(T, 10);
if f==1   
hist(T,10)
title(['average period is',  num2str(m)])
end