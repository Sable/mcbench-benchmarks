function hg=ConflHyperGeomFun(a,b,x);

%     M(a,b,x)
%     Input  : a  --- Parameter
%     b  --- Parameter ( b <> 0,-1,-2,... )
%     x  --- (Vector) argument
%     Output:  HG --- M(a,b,x)
%     ===================================================
% NO scaling is applied to the output.
% Uses Kummer's transformation when appropiate.
% Abramowitz & Stegun, 13.1.27.
%
% This is a modified version of the function available at:
% http://ceta.mit.edu/comp_spec_func/
% For more information about this function and others, consult the above
% webpage, please.
%
% The version you are looking at now can handle vector arguments.
%
% Copyright 2007: Delft University of Technology, Information and
% Communication Theory Group. The software is free for non-commercial use.
% This program comes WITHOUT ANY WARRANTY.
%
% Last modified: 25-6-2007.

hg=zeros(size(x));
% Split up into all different relevant cases of x.
I1=find(x==0);
if ~isempty(I1)
    hg(I1)=1;
end
I2a=find(x<0 & abs(x)<=30+abs(b));
I2b=find(x<0 & abs(x)>30+abs(b));
if ~isempty(I2a)
    hg(I2a)=chgfunc(b-a,b,abs(x(I2a))).*exp(x(I2a));
end
if ~isempty(I2b)
    hg(I2b)=chgfunc(b-a,b,abs(x(I2b))).*exp(x(I2b));
end
I3a=find(x>0 & x<=30+abs(b));
I3b=find(x>0 & x>30+abs(b));
if ~isempty(I3a)
    hg(I3a)=chgfunc(a,b,x(I3a));
end
if ~isempty(I3b)
    hg(I3b)=chgfunc(a,b,x(I3b));
end

function hg=chgfunc(a,b,x);

ta=[];tb=[];xg=[];tba=[];
pi=3.141592653589793d0;
a0=a;
a1=a;
% first element is used in tests below
x0=x(1);
hg=0.0d0;
if (b == 0.0d0|b == -abs(fix(b))) ;
    hg=1.0d+300;
elseif (a == 0.0d0|x0 == 0.0d0);
    hg=1.0d0;
elseif (a == -1.0d0);
    hg=1.0d0-x./b;
elseif (a == b);
    hg=exp(x);
elseif (a-b == 1.0d0);
    hg=(1.0d0+x./b).*exp(x);
elseif (a == 1.0d0&b == 2.0d0);
    hg=(exp(x)-1.0d0)./x;
elseif (a == fix(a)&a < 0.0d0);
    m=fix(-a);
    r=1.0d0;
    hg=1.0d0;
    for  k=1:m;
        r=r.*(a+k-1.0d0)./k./(b+k-1.0d0).*x;
        hg=hg+r;
    end;
end;
if (hg ~= 0.0d0) return; end;
if (x0 < 0.0d0) ;
    a=b-a;
    a0=a;
    x=abs(x);x0=x(1);
end;
if (a < 2.0d0) nl=0; end;
if (a >= 2.0d0) ;
    nl=1;
    la=fix(a);
    a=a-la-1.0d0;
end;
for  n=0:nl;
    if (a0 >= 2.0d0) a=a+1.0d0; end;
    if (x0 <= 30.0d0+abs(b)|a < 0.0d0) ;
        hg=ones(size(x));
        rg=hg;
        Ir=1:length(x);
        for  j=1:500;
            rg(Ir)=rg(Ir).*(a+j-1.0d0)./(j.*(b+j-1.0d0)).*x(Ir);
            hg(Ir)=hg(Ir)+rg(Ir);
            index=find(abs(rg(Ir))>eps*abs(hg(Ir)));
          
            if isempty(index),break;else Ir=Ir(index);end
        end;
    else;
        ta=gamma(a);
        tb=gamma(b);
        xg=b-a;
        tba=gamma(xg);
        sum1=1.0d0;
        sum2=1.0d0;
        r1=1.0d0;
        r2=1.0d0;
        for  i=1:8;
            r1=-r1.*(a+i-1.0d0).*(a-b+i)./(x.*i);
            r2=-r2.*(b-a+i-1.0d0).*(a-i)./(x.*i);
            sum1=sum1+r1;
            sum2=sum2+r2;
        end;
        hg1=tb./tba.*x.^(-a).*cos(pi.*a).*sum1;
        hg2=tb./ta.*exp(x).*x.^(a-b).*sum2;
        hg=hg1+hg2;
    end;
    if (n == 0) y0=hg; end;
    if (n == 1) y1=hg; end;
end;
if (a0 >= 2.0d0) ;
    for  i=1:la-1;
        hg=((2.0d0.*a-b+x).*y1+(b-a).*y0)./a;
        y0=y1;
        y1=hg;
        a=a+1.0d0;
    end;
end;
a=a1;
