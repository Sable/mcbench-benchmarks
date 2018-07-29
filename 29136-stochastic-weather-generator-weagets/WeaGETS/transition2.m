function [a] = transition2(PnP,Y,D)
%
% This function calculates the transition matrix [a] from a time series
% of daily precipitation.  The matrix has a dimension a(8,D), where D is
% the number of days analyzed in a calendar year (usually 365).  These
% values are used in a second-order Markov chain for occurence generation.
%
% The elements of the matrices are as follow:
%
%    a(1,:) correspond to a000
%    a(2,:) correspond to a001
%    a(3,:) correspond to a010
%    a(4,:) correspond to a011
%    a(5,:) correspond to a100
%    a(6,:) correspond to a101
%    a(7,:) correspond to a110
%    a(8,:) correspond to a111
%
% to calculate the transitions from state i on day n-2 and n-1 to state j on day n
% a matrix PnPp is produced from PnP by shifting the columns to the right
% and a matrix PnPpp is produced from PnPp by shifting the columns to the
% right.
% rsults will be accurate if D is equal to 365.  There is a lost in accuracy
% if D is smaller than 365
%
PnPp(:,2:D)=PnP(:,1:D-1);
PnPp(2:Y,1)=PnP(1:Y-1,D);

PnPpp(:,2:D)=PnPp(:,1:D-1);
PnPpp(2:Y,1)=PnPp(1:Y-1,D);

%
a000=zeros(Y,D);
a001=a000;

a010=a000;
a011=a000;

a100=a000;
a101=a000;

a110=a000;
a111=a000;


[k]=find(PnP==0&PnPp==0&PnPpp==0);
a000(k)=1;

[k]=find(PnP==1&PnPp==0&PnPpp==0);
a001(k)=1;



[k]=find(PnP==0&PnPp==1&PnPpp==0);
a010(k)=1;

[k]=find(PnP==1&PnPp==1&PnPpp==0);
a011(k)=1;



[k]=find(PnP==0&PnPp==0&PnPpp==1);
a100(k)=1;

[k]=find(PnP==1&PnPp==0&PnPpp==1);
a101(k)=1;



[k]=find(PnP==0&PnPp==1&PnPpp==1);
a110(k)=1;

[k]=find(PnP==1&PnPp==1&PnPpp==1);
a111(k)=1;


%
% transitions are stored in matrix a(16,D)
%
a(1,:)=sum(a000);
a(2,:)=sum(a001);

a(3,:)=sum(a010);
a(4,:)=sum(a011);

a(5,:)=sum(a100);
a(6,:)=sum(a101);

a(7,:)=sum(a110);
a(8,:)=sum(a111);




