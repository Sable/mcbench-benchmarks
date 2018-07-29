function [M] = covar(x1,x2,k,n)
%
% this function calculates the lag k covariance matrice
% for three time series. Each time series is a 1xn vector
%
if k == 0
   %
   % lag 0 covariance matrix
   %
   p1=find(x1~=0);
   p2=find(x2~=0);
   %p3=find(x3~=0);
   p12=find(x1~=0 & x2~=0);
   %p13=find(x1~=0 & x3~=0);
   %p23=find(x2~=0 & x3~=0);
 %  m1=mean(x1(p1));
 %  m2=mean(x2(p2));
 %  m3=mean(x3(p3));
   m1=0;    % x1, x2 and x3 are residuals characterized by N(0,1)
   m2=0;
   %m3=0;
 %  M(1,1)=std(x1(p1));
 %  M(2,2)=std(x2(p2));
 %  M(3,3)=std(x3(p3));
   M(1,1)=1;   % x1, x2 and x3 are residuals characterized by N(0,1)
   M(2,2)=1;
   %M(3,3)=1;
   M(1,2)=sum((x1(p12)-m1).*(x2(p12)-m2))/(length(p12)-1);
   M(2,1)=M(1,2);
   %M(1,3)=sum((x1(p13)-m1).*(x3(p13)-m3))/(length(p13)-1);
   %M(3,1)=M(1,3);
   %M(2,3)=sum((x2(p23)-m2).*(x3(p23)-m3))/(length(p23)-1);
   %M(3,2)=M(2,3);
else
   %
   % lag k covariance matrix
   %
   x1t=x1(1:n-k);
   x1tk=x1(k+1:n);
   x2t=x2(1:n-k);
   x2tk=x2(k+1:n);
   %x3t=x3(1:n-k);
   %x3tk=x3(k+1:n);
   p1t=find(x1t~=0);
   p2t=find(x2t~=0);
   %p3t=find(x3t~=0);
   p1tk=find(x1tk~=0);
   p2tk=find(x2tk~=0);
   %p3tk=find(x3tk~=0); 
 %  m1t=mean(x1t(p1t));
 %  m1tk=mean(x1tk(p1tk));
 %  m2t=mean(x2t(p2t));
 %  m2tk=mean(x2tk(p2tk));
 %  m3t=mean(x3t(p3t));
 %  m3tk=mean(x3tk(p3tk));
 m1t=0;   % x1, x2 and x3 are residuals characterized by N(0,1)
 m1tk=0;
 m2t=0;
 m2tk=0;
 %m3t=0;
 %m3tk=0;
   %
   p11=find(x1t~=0 & x1tk~=0);
   p22=find(x2t~=0 & x2tk~=0);
   %p33=find(x3t~=0 & x3tk~=0);
   p12=find(x1t~=0 & x2tk~=0);
   %p13=find(x1t~=0 & x3tk~=0);
   p21=find(x2t~=0 & x1tk~=0);
   %p23=find(x2t~=0 & x3tk~=0);
   %p31=find(x3t~=0 & x1tk~=0);
   %p32=find(x3t~=0 & x2tk~=0);
   %
   M(1,1)=sum((x1t(p11)-m1t).*(x1tk(p11)-m1tk))/(length(p11)-k-1);
   M(2,2)=sum((x2t(p22)-m2t).*(x2tk(p22)-m2tk))/(length(p22)-k-1);
   %M(3,3)=sum((x3t(p33)-m3t).*(x3tk(p33)-m3tk))/(length(p33)-k-1);
   M(1,2)=sum((x1t(p12)-m1t).*(x2tk(p12)-m2tk))/(length(p12)-k-1);
   M(2,1)=sum((x2t(p21)-m2t).*(x1tk(p21)-m1tk))/(length(p21)-k-1);
   %M(1,3)=sum((x1t(p13)-m1t).*(x3tk(p13)-m3tk))/(length(p13)-k-1);
   %M(3,1)=sum((x3t(p31)-m3t).*(x1tk(p31)-m1tk))/(length(p31)-k-1);
   %M(2,3)=sum((x2t(p23)-m2t).*(x3tk(p23)-m3tk))/(length(p23)-k-1);
   %M(3,2)=sum((x3t(p32)-m3t).*(x2tk(p32)-m2tk))/(length(p32)-k-1);
end


