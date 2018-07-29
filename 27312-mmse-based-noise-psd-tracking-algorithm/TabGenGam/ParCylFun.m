function [pdf,pdd,factor]=ParCylFun(v,x);
%function [pdf,pdd,factor]=ParCylFun(v,x);
% Computes SCALED parabolic cylinder functions and their derivatives:
% 'pdf' and 'pdd' must be multiplied by exp(factor) to get the true values.
%       Input:   x --- Argument of Dv(x); x can be a VECTOR.
%                v --- Order of Dv(x)
%                PDF --- Dv(x)
%                PDD --- Dv'(x)
%                factor --- log of scaling factor
%       Routines called:
%             (1) DVSA for computing Dv(x) for small |x|
%             (2) DVLA for computing Dv(x) for large |x|
%       ====================================================
% This is a modified version of the function available at:
% http://ceta.mit.edu/comp_spec_func/
% For more information about this function and others, consult the above
% webpage, please.
%
% The version you are looking at now can handle vector arguments and
% contains some other optimizations to increase the speed as well.
%
% Copyright 2007: Delft University of Technology, Information and
% Communication Theory Group. The software is free for non-commercial use.
% This program comes WITHOUT ANY WARRANTY.
%
% Last modified: 25-6-2007.

L=length(x);
dv=zeros(1,L);dp=dv;pdf=dv;pdd=dv;
% Turn x into a row vector
x=x(:)';
xa=abs(x);
factor=-sign(x).*x.*x/4;
% Split up into all different relevant cases of x and abs(x).
% for v>=0
I1=find(xa<=5.8);
I2=find(xa>5.8 & x<=1000);
% for v<0
J1=find(x<=0 & xa<=5.8);
J2=find(x<=0 & xa>5.8);
J3=find(x>0 & x<=2);
J4=find(x>2 & x<=5.8);
J5=find(x>5.8 & x<=1000);
% for all v
K1=find(x>1000);
% Hanlde all cases
if ~isempty(I1) & v>=0
    [pdf(I1),pdd(I1)]=pbdv(v,x(I1));
end
if ~isempty(I2) & v>=0
    [pdf(I2),pdd(I2)]=pbdv(v,x(I2));
end
if ~isempty(J1) & v<0
    [pdf(J1),pdd(J1)]=pbdv(v,x(J1));
end
if ~isempty(J2) & v<0
    [pdf(J2),pdd(J2)]=pbdv(v,x(J2));
end
if ~isempty(J3) & v<0
    [pdf(J3),pdd(J3)]=pbdv(v,x(J3));
end
if ~isempty(J4) & v<0
    [pdf(J4),pdd(J4)]=pbdv(v,x(J4));
end
if ~isempty(J5) & v<0
    [pdf(J5),pdd(J5)]=pbdv(v,x(J5));
end
if ~isempty(K1)
    [pdf(K1),pdd(K1)]=pbdv(v,x(K1));
end

function [pdf,pdd]=pbdv(v,x);
% x are the selected elements of the original input
v1=[];pd1=[];v0=[];pd0=[];v2=[];f1=[];f0=[];
% first element is used in tests below
x1=x(1);
xa=abs(x);xa1=xa(1);

vh=v;
I1=find(x>=0);I2=find(x<0);
% Problems with order 0. Therefore:
if v==0,pdf(I1)=ones(1,length(I1));pdf(I2)=exp(-(x.^2)/2);pdd=-0.5.*x.*pdf;return,end
v=v+(abs(1.0d0).*sign(v));
nv=fix(v);
v0=v-nv;
na=abs(nv);
ep(I1)=ones(1,length(I1));
ep(I2)=exp(-.5d0.*x(I2).*x(I2));
if (na >= 1) ja=1; end;

if x1<=1500

if (v >= 0.0) ;
    if (v0 == 0.0) ;
        pd0=ep;
        pd1=x.*ep;
    else;
        for  l=0:ja;
            v1=v0+l;
            if (xa1<=5.8) [pd1]=dvsa(v1,x); end;
            if (xa1 > 5.8) [pd1]=dvla(v1,x); end;
            if (l == 0) pd0=pd1; end;
        end;
    end;
    dv(0+1,:)=pd0;
    dv(1+1,:)=pd1;
    for  k=2:na;
        pdf=x.*pd1-(k+v0-1.0d0).*pd0;
        dv(k+1,:)=pdf;
        pd0=pd1;
        pd1=pdf;
    end;
else;
    if (x1 <= 0.0) ;
        if (xa1 <= 5.8d0)  ;
            [pd0]=dvsa(v0,x);
            v1=v0-1.0d0;
            [pd1]=dvsa(v1,x);
        else;
            [pd0]=dvla(v0,x);
            v1=v0-1.0d0;
            [pd1]=dvla(v1,x);
        end;
        dv(0+1,:)=pd0;
        dv(1+1,:)=pd1;
        for  k=2:na;
            pd=(-x.*pd1+pd0)./(k-1.0d0-v0);
            dv(k+1,:)=pd;
            pd0=pd1;
            pd1=pd;
        end;
    elseif (x1 <= 2.0);
        v2=nv+v0;
        if (nv == 0) v2=v2-1.0d0; end;
        nk=fix(-v2);
        [f1]=dvsa(v2,x);
        v1=v2+1.0d0;
        [f0]=dvsa(v1,x);
        dv(nk+1,:)=f1;
        dv(nk-1+1,:)=f0;
        for  k=nk-2:-1:0;
            f=x.*f0+(k-v0+1.0d0).*f1;
            dv(k+1,:)=f;
            f1=f0;
            f0=f;
        end;
    else;
        if (xa1 <= 5.8) [pd0]=dvsa(v0,x); end;
        if (xa1 > 5.8) [pd0]=dvla(v0,x); end;
        dv(0+1,:)=pd0;
        m=100+na;
        f1=0.0d0;
        f0=1.0d-30;
        for  k=m:-1:0;
            f=x.*f0+(k-v0+1.0d0).*f1;
            if (k <= na) dv(k+1,:)=f; end;
            f1=f0;
            f0=f;
        end;
        s0=pd0./f;
        for  k=0:na;
            dv(k+1,:)=s0.*dv(k+1,:);
        end;
    end;
end;
for  k=0:na-1;
    v1=abs(v0)+k;
    if (v >= 0.0d0) ;
        dp(k+1,:)=0.5d0.*x.*dv(k+1,:)-dv(k+1+1,:);
    else;
        dp(k+1,:)=-0.5d0.*x.*dv(k+1,:)-v1.*dv(k+1+1,:);
    end;
end;
pdf=dv(na-1+1,:);
pdd=dp(na-1+1,:);
v=vh;
%asymptotic for large values
else
  a=-v-0.5;
  mult=1-(a+0.5)*(a+3/2)./(2*x.^2) + (a+0.5)*(a+3/2)*(a+5/2)*(a+7/2)./(2*4*x.^4);
  pdf=(x.^(-a-0.5)).*mult.*ep;
  pdd=-0.5.*x.*pdf;
end

return;

function [pd]=dvsa(va,x);
%                for small argument
%       Input:   x  --- Argument
%                va --- Order
%       Output:  PD --- Dv(x)
%       Routine called: GAMMA for computing â(x)
%       ===================================================
va0=[];ga0=[];g1=[];vt=[];g0=[];vm=[];gm=[];
eps=1.0d-15;
pi=3.141592653589793d0;
sq2=sqrt(2.0d0);

I1=find(x>=0);I2=find(x<0);
ep(I1)=ones(1,length(I1));
ep(I2)=exp(-.5d0.*x(I2).*x(I2));

pd=zeros(1,length(x));r=pd;
va0=0.5d0.*(1.0d0-va);

I1=find(x==0);I2=find(x~=0);

if (va == 0.0) ;
    pd=ep;
else;
    if (~isempty(I1)) ;
        if (va0 <= 0.0&va0 == fix(va0)) ;
            pd(I1)=0.0d0;
        else;
            [ga0]=gamma(va0);
            pd(I1)=sqrt(pi)./(2.0d0.^(-.5d0.*va).*ga0);
        end;
    end
    if (~isempty(I2))
        [g1]=gamma(-va);
        a0(I2)=2.0d0.^(-0.5d0.*va-1.0d0).*ep(I2)./g1;
        vt=-.5d0.*va;
        [g0]=gamma(vt);
        pd(I2)=g0;
        % quotient
        r(I2)=1.0d0;
        % Intitialisation of the gamma-recursion
        % m=-1 en m=0
        % Don't use for va=-1,0,1,2,...
        rvlag=1;if round(va)==va & va>-2,rvlag=0;end
        if rvlag
            gamodd=gamma(-0.5*(1+va));
            gameven=gamma(-0.5*va);
        end
        % I2r contains the indices of the elements left that have not yet
        % met the criterion for exiting the loop.
        I2r=I2;
        for  m=1:250;
            % Gamma argument goes with steps of 0.5
            % Use recursion
            vm=.5d0.*(m-va);
            if rvlag
                if floor(m/2)==m/2
                    gameven=gameven.*(vm-1);
                    gm=gameven;
                else %m odd
                    gamodd=gamodd.*(vm-1);
                    gm=gamodd;
                end
            else
                [gm]=gamma(vm);
            end
            r(I2r)=-r(I2r).*sq2.*x(I2r)./m;
            r1(I2r)=gm.*r(I2r);
            pd(I2r)=pd(I2r)+r1(I2r);
            index=find(abs(r1(I2r)) >= eps*abs(pd(I2r)));
            if isempty(index),break,else I2r=I2r(index);end
        end;
        pd(I2)=a0(I2).*pd(I2);
    end;
end;
return;

function [pd]=dvla(va,x);
%                for large argument
%       Input:   x  --- Argument
%                va --- Order
%       Output:  PD --- Dv(x)
%       Routines called:
%             (1) VVLA for computing Vv(x) for large |x|
%             (2) GAMMA for computing â(x)
%       ====================================================
x1=[];vl=[];gl=[];
pi=3.141592653589793d0;
eps=1.0d-12;

I1=find(x>=0);I2=find(x<0);
ep(I1)=ones(1,length(I1));
ep(I2)=exp(-.5d0.*x(I2).*x(I2));

a0=abs(x).^va.*ep;
pd=ones(1,length(x));r=pd;
I=find(x<0);
Ir=1:length(x);
for  k=1:16;
    r(Ir)=-0.5d0.*r(Ir).*(2.0.*k-va-1.0).*(2.0.*k-va-2.0)./(k.*x(Ir).*x(Ir));
    pd(Ir)=pd(Ir)+r(Ir);
    index=find(abs(r(Ir))>=eps*abs(pd(Ir)));
    if isempty(index),break; else Ir=Ir(index);end
end;
pd=a0.*pd;
if (~isempty(I)) ;
    x1(I)=-x(I);
    [vl(I)]=vvla(va,x1(I));
    [gl]=gamma(-va);
    pd(I)=pi.*vl(I)./gl+cos(pi.*va).*pd(I);
end;
return;

function [pv]=vvla(va,x);
%                for large argument
%       Input:   x  --- Argument
%                va --- Order
%       Output:  PV --- Vv(x)
%       Routines called:
%             (1) DVLA for computing Dv(x) for large |x|
%             (2) GAMMA for computing â(x)
%       ===================================================
x1=[];pdl=[];gl=[];
pi=3.141592653589793d0;
eps=1.0d-12;

I1=find(x>=0);I2=find(x<0);
qe(I1)=ones(1,length(I1));
qe(I2)=exp(-.5d0.*x(I2).*x(I2));
a0=abs(x).^(-va-1.0d0).*sqrt(2.0d0./pi).*qe;
pv=ones(1,length(x));r=pv;
I=find(x<0);
Ir=1:length(x);
for  k=1:18;
    r(Ir)=0.5d0.*r(Ir).*(2.0.*k+va-1.0).*(2.0.*k+va)./(k.*x(Ir).*x(Ir));
    pv(Ir)=pv(Ir)+r(Ir);
    index=find(abs(r(Ir))>=eps*abs(pv(Ir)));
    if isempty(index),break;else Ir=Ir(index);end
end;
pv=a0.*pv;
if (~isempty(I)) ;
    x1(I)=-x(I);
    [pdl(I)]=dvla(va,x1(I));
    [gl]=gamma(-va);
    dsl=sin(pi.*va).*sin(pi.*va);
    pv(I)=dsl.*gl./pi.*pdl(I)-cos(pi.*va).*pv(I);
end;
return;

