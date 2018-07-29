function [a] = transition3(PnP,Y,D)
%
% This function calculates the transition matrix [a] from a time series
% of daily precipitation.  The matrix has a dimension a(8,D), where D is
% the number of days analyzed in a calendar year (usually 365).
%
% The elements of the matrices are as follow:
%
%    a(1,:) correspond to a000:  transition from a dry day on day n-2, dry day on day n-1 to a dry day on day n
%    a(2,:) correspond to a001:  transition from a dry day on day n-2, dry day on day n-1 to a wet day on day n
%    a(3,:) correspond to a010:  transition from a dry day on day n-2, wet day on day n-1 to a dry day on day n
%    a(4,:) correspond to a011:  transition from a dry day on day n-2, wet day on day n-1 to a wet day on day n
%    a(5,:) correspond to a100:  transition from a wet day on day n-2, dry day on day n-1 to a dry day on day n
%    a(6,:) correspond to a101:  transition from a wet day on day n-2, dry day on day n-1 to a wet day on day n
%    a(7,:) correspond to a110:  transition from a wet day on day n-2, wet day on day n-1 to a dry day on day n
%    a(8,:) correspond to a111:  transition from a wet day on day n-2, wet day on day n-1 to a wet day on day n
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

PnPppp(:,2:D)=PnPpp(:,1:D-1);
PnPppp(2:Y,1)=PnPpp(1:Y-1,D);

%
a0000=zeros(Y,D);
a0001=a0000;
a0010=a0000;
a0011=a0000;
a0100=a0000;
a0101=a0000;
a0110=a0000;
a0111=a0000;
a1000=a0000;
a1001=a0000;
a1010=a0000;
a1011=a0000;
a1100=a0000;
a1101=a0000;
a1110=a0000;
a1111=a0000;

[k]=find(PnP==0&PnPp==0&PnPpp==0&PnPppp==0);
a0000(k)=1;

[k]=find(PnP==1&PnPp==0&PnPpp==0&PnPppp==0);
a0001(k)=1;

[k]=find(PnP==0&PnPp==1&PnPpp==0&PnPppp==0);
a0010(k)=1;

[k]=find(PnP==1&PnPp==1&PnPpp==0&PnPppp==0);
a0011(k)=1;

[k]=find(PnP==0&PnPp==0&PnPpp==1&PnPppp==0);
a0100(k)=1;

[k]=find(PnP==1&PnPp==0&PnPpp==1&PnPppp==0);
a0101(k)=1;

[k]=find(PnP==0&PnPp==1&PnPpp==1&PnPppp==0);
a0110(k)=1;

[k]=find(PnP==1&PnPp==1&PnPpp==1&PnPppp==0);
a0111(k)=1;

[k]=find(PnP==0&PnPp==0&PnPpp==0&PnPppp==1);
a1000(k)=1;

[k]=find(PnP==1&PnPp==0&PnPpp==0&PnPppp==1);
a1001(k)=1;

[k]=find(PnP==0&PnPp==1&PnPpp==0&PnPppp==1);
a1010(k)=1;

[k]=find(PnP==1&PnPp==1&PnPpp==0&PnPppp==1);
a1011(k)=1;

[k]=find(PnP==0&PnPp==0&PnPpp==1&PnPppp==1);
a1100(k)=1;

[k]=find(PnP==1&PnPp==0&PnPpp==1&PnPppp==1);
a1101(k)=1;

[k]=find(PnP==0&PnPp==1&PnPpp==1&PnPppp==1);
a1110(k)=1;

[k]=find(PnP==1&PnPp==1&PnPpp==1&PnPppp==1);
a1111(k)=1;
%
% transitions are stored in matrix a(16,D)
%
a(1,:)=sum(a0000);
a(2,:)=sum(a0001);
a(3,:)=sum(a0010);
a(4,:)=sum(a0011);
a(5,:)=sum(a0100);
a(6,:)=sum(a0101);
a(7,:)=sum(a0110);
a(8,:)=sum(a0111);
a(9,:)=sum(a1000);
a(10,:)=sum(a1001);
a(11,:)=sum(a1010);
a(12,:)=sum(a1011);
a(13,:)=sum(a1100);
a(14,:)=sum(a1101);
a(15,:)=sum(a1110);
a(16,:)=sum(a1111);



