function [v,lag]=ami(x,y,lag)
%Usage: [v,lag]=ami(x,y,lag)
%
% Calculates the mutual average information of x and y with a possible lag.
% 
%
% v is the average mutual information. (relative units see below)
% x & y is the time series. (column vectors)
% lag is a vector of time lags.
%
% (A peak in V for lag>0 means y is leading x.)
% 
% v is given as how many bits x and y has in common relative to how 
% many bits is needed for the internally binned representation of x or y.
% This is done to make the result close to independent bin size.
%
% For optimal binning: transform x and y into percentiles prior to running
% ami. See e.g. boxpdf at matlab central.
%
% http://www.imt.liu.se/~magnus/cca/tutorial/node16.html
%
% Aslak Grinsted feb2006 
% http://www.glaciology.net
% (Inspired by mai.m by Alexandros Leontitsis)

if nargin==0
    error('You should provide a time series.');
end

if nargin<2
    y=x;
end


x=x(:);
y=y(:);
n=length(x);
if n~=length(y)
    error('x and y should be same length.');
end

if nargin<3
    lag=0;
    if nargin<2
        lag=0:min(n/2-1,20); %compatible with mai.m
    end
else
    lag=round(lag);
end


% The mutual average information
x=x-min(x);   
x=x*(1-eps)/max(x);
y=y-min(y);
y=y*(1-eps)/max(y);

v=zeros(size(lag));
lastbins=nan;
for ii=1:length(lag)

    abslag=abs(lag(ii));
    
    % Define the number of bins
    bins=floor(1+log2(n-abslag)+0.5);%as mai.m
    if bins~=lastbins
        binx=floor(x*bins)+1;
        biny=floor(y*bins)+1;
    end
    lastbins=bins;

    Pxy=zeros(bins);
    
	for jj=1:n-abslag
        kk=jj+abslag;
        if lag(ii)<0 
            temp=jj;jj=kk;kk=temp;%swap
        end
        Pxy(binx(kk),biny(jj))=Pxy(binx(kk),biny(jj))+1;
    end
    Pxy=Pxy/(n-abslag);
    Pxy=Pxy+eps; %avoid division and log of zero
    Px=sum(Pxy,2);
    Py=sum(Pxy,1);
    
    q=Pxy./(Px*Py);
    
    q=Pxy.*log2(q);
    
    v(ii)=sum(q(:))/log2(bins); %log2bins is what you get if x=y.
%   Equivalent formulation (slightly slower) 
%     Hx=-sum(Px.*log2(Px));
%     Hy=-sum(Py.*log2(Py));
%     Hxy=-sum(Pxy(:).*log2(Pxy(:)));
%     v(ii)=Hx+Hy-Hxy;
end
