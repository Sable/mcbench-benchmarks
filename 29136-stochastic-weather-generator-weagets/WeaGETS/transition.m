function [a] = transition(PnP,Y,D)
%
% This function calculates the transition matrix [a] from a time series
% of daily precipitation.  The matrix has a dimension a(4,D), where D is
% the number of days analyzed in a calendar year (usually 365).
%
% The elements of the matrices are as follow:
%
%    a(1,:) correspond to a00:  transition from a dry day on day n-1 to a dry day on day n
%    a(2,:) correspond to a01:  transition from a dry day on day n-1 to a wet day on day n
%    a(3,:) correspond to a10:  transition from a wet day on day n-1 to a dry day on day n
%    a(4,:) correspond to a11:  transition from a wet day on day n-1 to a wet day on day n
%
% to calculate the transitions from state i on day n-1 to state j on day n
% a matrix PnPp is produced from PnP by shifting the columns to the right
% rsults will be accurate if D is equal to 365.  There is a lost in accuracy
% if D is smaller than 365
%
PnPp(:,2:D)=PnP(:,1:D-1);
PnPp(2:Y,1)=PnP(1:Y-1,D);  % take the december 31st of year i and put it in the first column of year i+1
                            % that is: the day preceding january 1st of
                            % this year is December 31st of the previous
                            % year.  PnPp(1,1) is defaulted to 0 since
                            % December of the previous year is outside the
                            % data
%
% subtract PnP frpm PnPp.  -1 correspond to a01  1 correspond to a10
%
a01=zeros(Y,D);
a10=a01;
a11=a01;
difP=PnPp-PnP;
[k]=find(difP == -1);
a01(k)=1;
[k]=find(difP == 1);
a10(k)=1;
%
% scalar multiplication of PnP and PnPp.  1 correspond to a11
%
prodP=PnP.*PnPp;
[k]=find(prodP == 1);
a11(k)=1;
%
% transitions are stored in matrix a(4,D)
%
a(2,:)=sum(a01);
a(3,:)=sum(a10);
a(4,:)=sum(a11);
%
% detection of NaN in either prodP or difP and determination
% of a00 by subtracting the a01, a10, a11 from the total number
% of years and taking into account the missing values
%
MNaN=isnan(prodP);
SNaN=sum(MNaN);
a(1,:)=Y-a(2,:)-a(3,:)-a(4,:)-SNaN;



