function [y,yl,yr]=IT2FLS(x,X,Y)

% y=IT2FLS(x,X,Y)
% Compute the output of an IT2 FLS. Dongrui Wu (drwu09@gmail.com), 3/11/2011
%
% x: Input to the IT2 FLS. Assume the FLS has N consequents and 1 consequent. Then, x can be a 1*N vector
%    or M*N matrix, each row corresponding to an input vector.
%
% X: Matrix describing the consequents part of the rulebase. Assume the rulebase has K rules:
%    IF x1 is X11 and x2 is X21, THEN y is y1
%    ...
%    IF x1 is X1K and x2 is X2K, THEN y is yK
% where X11-X2K are IT2 FSs and y1-yK are crisp intervals. Then,
%      X=[MF of X11, MF of X21;
%         ...
%         MF of X1K, MF of X2K]
% Note that each MF is represented by 9 points.
%
% Y: Matrix describing the consequent part of the rulebase. For the above rulebase,
%    Y=[y1;
%       ...
%       yK];
%
% y: Output of the IT2 FLS. It has as many rows as x, each row is the output for the corresponding row of x.
%    y=(yl+yr)/2
%
% yl: Lower bounds of the intervals output by the type-reducer.
%
% yr: Upper bounds of the intervals output by the type-reducer.
%
% Dongrui Wu, GE Research (drwu09@gmail.com)
%

if nargin<3
    display('Function IT2FLS: Must have three arguments. Abort.'); return;
end

if size(X,1)~=size(Y,1)
    display('Function IT2FLS: X must have the same number of rows as Y. Abort.'); return;
end

if size(x,2)~=size(X,2)/9
    display('Function IT2FLS: The number of columns in x must be equal to the number of IT2 FSs in each row of X. Abort'); return;
end

y=zeros(size(x,1),1);
yr=y; yl=y;
for i=1:size(x,1)
    fl=ones(1,size(X,1)); fu=fl;
    for j=1:size(X,1)
        for k=1:size(X,2)/9
            fu(j)=fu(j)*mg(x(i,k),X(j,9*(k-1)+(1:4)));
            fl(j)=fl(j)*X(j,9*k)*mg(x(i,k),X(j,9*(k-1)+(5:8)));
        end
    end
    [y(i),yl(i),yr(i)]=EIASC(Y(:,1)',Y(:,2)',fl,fu);
end


function [y,yl,yr,l,r]=EIASC(Xl,Xr,Wl,Wr,needSort)

%
% function [y,yl,yr,l,r]=EIASC(Xl,Xr,Wl,Wr,needSort)
%
% function to implement the EIASC algorithm in:
%
% D. Wu and M. Nie, "Comparison and Practical Implementation of Type-Reduction Algorithms for Type-2 
% Fuzzy Sets and Systems," IEEE International Conference on Fuzzy Systems, Taipei, Taiwan, June 2011.
%
% Dongrui WU, GE Research (drwu09@gmail.com), 7/18/2010
%
% Xl: A row vector containing the lower bounds of x
% Xr: A row vector containing the upper bounds of x
% Wl: A row vector containing the lower bounds of w
% Wr: A row vector containing the upper bounds of w
% needSort: “1” if at least one of Xl and Xr is not in ascending order. 
%           “0” if both Xl and Xr are in ascending order. Default “1.”
%y: (yl+yr)/2
%yl: lower bound of the type-reduced output
%yr: upper bound of the type-reduced output
%l: switch point for yl
%r: switch point for yr

ly=length(Xl); XrEmpty=isempty(Xr);
if XrEmpty;  Xr=Xl; end
if max(Wl)==0
    yl=min(Xl); yr=max(Xr);
    y=(yl+yr)/2;  l=1; r=ly-1; return;
end
index=find(Wr<10^(-10));
if length(index)==ly
    yl=min(Xl); yr=max(Xr);
    y=(yl+yr)/2; l=1; r=ly-1; return;
end
Xl(index)=[]; Xr(index)=[];
Wl(index)=[]; Wr(index)=[];
if nargin==4;  needSort=1; end

% Compute yl
if  needSort
    [Xl,index]=sort(Xl); Xr=Xr(index);
    Wl=Wl(index); Wr=Wr(index);
end
Wl2=Wl; Wr2=Wr;
for i=length(Xl):-1:2 % Make Xl unique
    if Xl(i)==Xl(i-1)
        Wl(i)=Wl(i)+Wl(i-1);
        Wr(i)=Wr(i)+Wr(i-1); Xl(i)=[];
        Wl(i-1)=[]; Wr(i-1)=[];
    end
end
ly=length(Xl);
if ly==1
    yl=Xl;  l=1;
else
    yl=Xl(end); l=1;
    a=Xl*Wl'; b=sum(Wl); 
    while l < ly && yl > Xl(l)
        a=a+Xl(l)*(Wr(l)-Wl(l));
        b=b+Wr(l)-Wl(l); 
        yl=a/b;   l=l+1;
    end
end

% Compute yr
if ~XrEmpty && needSort==1
    [Xr,index]=sort(Xr);
    Wl=Wl2(index); Wr=Wr2(index);
end
if ~XrEmpty
    for i=length(Xr):-1:2 % Make Xr unique
        if Xr(i)==Xr(i-1)
            Wl(i)=Wl(i)+Wl(i-1);
            Wr(i)=Wr(i)+Wr(i-1); Xr(i)=[];
            Wl(i-1)=[]; Wr(i-1)=[];
        end
    end
end
ly=length(Xr);
if ly==1
    yr=Xr; r=1;
else
    r=ly; yr=Xr(1); 
    a=Xr*Wl'; b=sum(Wl);
    while r>0 && yr < Xr(r)
        a=a+Xr(r)*(Wr(r)-Wl(r));
        b=b+Wr(r)-Wl(r); 
        yr=a/b;  r=r-1;
    end
end
y=(yl+yr)/2;


function u=mg(x,xMF,uMF)

% u=mg(x,xMF,uMF)
% function to compute the membership grades of x on a T1 FS
% Dongrui WU, GE Research (drwu09@gmail.com), 7/18/2010
%
% xMF: x-coordinates of the T1 FS
% uMF: u-coordinates of the T1 FS; default to be [0 1 1 0]
% u: membership of x on the T1 FS

if nargin==2
    uMF=[0 1 1 0];
elseif length(xMF)~=length(uMF)
    display('Function mg: xMF and uMF must have the same length. Abort.'); return;
end

[xMF,index]=sort(xMF); uMF=uMF(index);

u=zeros(size(x));
for i=1:length(x)
    if x(i)<=xMF(1)
        if xMF(1)==xMF(2)
            u(i)=1;
        end
    elseif x(i)>=xMF(end)
        if xMF(end-1)==xMF(end)
            u(i)=1;
        end
    else
        left=find(xMF<x(i),1,'last');     right=left+1;
        u(i)=uMF(left)+(uMF(right)-uMF(left))*(x(i)-xMF(left))/(xMF(right)-xMF(left));
    end
end

