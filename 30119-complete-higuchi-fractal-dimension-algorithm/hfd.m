function xhfd=hfd(x,kmax)
%function xhfd=hfd(x,kmax)
%Input:
%x: (either column or row) vector of length N
%kmax: maximum value of k
%Output:
%xhfd: Higuchi fractal dimension of x

if ~exist('kmax','var')||isempty(kmax),
    kmax=5;
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x=x(:)';
N=length(x);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Lmk=zeros(kmax,kmax);
for k=1:kmax,
    for m=1:k,
        Lmki=0;
        for i=1:fix((N-m)/k),
            Lmki=Lmki+abs(x(m+i*k)-x(m+(i-1)*k));
        end;
        Ng=(N-1)/(fix((N-m)/k)*k);
        Lmk(m,k)=(Lmki*Ng)/k; % Here is the problem in the code by Mr. Tikkuhirvi & Mr. Aino
    end;
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Lk=zeros(1,kmax);
for k=1:kmax,
    Lk(1,k)=sum(Lmk(1:k,k))/k;
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lnLk=log(Lk);
lnk=log(1./[1:kmax]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
b=polyfit(lnk,lnLk,1);
xhfd=b(1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
