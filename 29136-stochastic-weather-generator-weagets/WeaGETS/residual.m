function [resid] = residual(Xw,Xd,aXw,aXd,sXw,sXd,Y,D)
%
%  'w' refers to time series on wet days
%  'd' refers to time series on dry days
%   X refers to observed time series
%   aX refers to average values of periodic time series (calculated by Fourier analysis)
%   sX refers to standard deviation of periodic time series (Fourier analysis)
%
residw=[];
residd=[];
%
for i = 1:Y
   resw=zeros(1,D);
   resd=resw;
   jw=find(Xw(i,:)~=-999 & Xw(i,:)~=0);
   jd=find(Xd(i,:)~=-999 & Xd(i,:)~=0);
   %
   resw(jw)=(Xw(i,jw)-aXw(jw))./sXw(jw);
   resd(jd)=(Xd(i,jd)-aXd(jd))./sXd(jd);
   %
   residw=[residw resw];
   residd=[residd resd];
   %
   clear resw;
   clear resd;
   %
end
resid=residw+residd;

