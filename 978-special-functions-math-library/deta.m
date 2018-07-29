function [f] = deta(z,k)
%DETA   Calculates Dirichlet functions of the form
%
%       f = sum((-1)^n/(k*n+1)^z)
%
%       over the entire complex plane
%       Z may be complex and any size
%       Best accuracy for Abs(z) < 100
%
%       Usage: f = deta(z)
%          or  f = deta(z,k)
%
%       where k determines which Dirichlet function to sum
%       For Eta (Zeta, Lambda):   k=1
%       For Betad: k=2
% 
%       This function can use a LOT of memory when size(z)
%       is large. Consider using the Memory and Pack commands.
%       Also, consider breaking z up into smaller chunks.
%
%       Requires a complex Gamma routine.
%       Tested under version 5.3.1
%  
%see also:  Zeta, Eta, Lambda, Betad
%see also:  sym/zeta.m
%see also:  mhelp zeta

%Andrew Odlyzko has Riemann Zeta critical line zeros listed on:
%http://www.research.att.com/~amo/zeta_tables/index.html

%Paul Godfrey
%pgodfrey@conexant.com
%March 24, 2001

if nargin==1
   k=1;
end
k=k(1);
if k<1 | k>2
   warning('Unknown function being calculated! Results valid only for Real(z)>0.5')
% k=1 --> Eta --> Zeta or Lambda --> Bern numbers
% k=2 --> Betad --> Euler numbers
end

[sizz]=size(z);
z=z(:).'; % make z a row vector
rz=real(z);
iz=imag(z);
iszero=find(z==0);
iseven=find(z==(round(z/2)*2)       & rz<0 & iz==0);
isodd= find(z==(round((z-1)/2)*2+1) & rz<0 & iz==0);
 
r=1/2; % reflection point
L=find(rz< r);
if ~isempty(L)
   zL=z(L);
   z(L)=1-zL;
end

%series coefficients were calculated using 
% c(m)=sum from n=m to 64 of (binomial(n,m)/2^n) for m=0:64

%coefficients are symmetrical about the 0.5 value. Each pair sums to +-1
%abs(coefficients) look like erfc(k*m)/2 due to binomial terms
%sum(cm) must = 0.5 = eta(0) = betad(0)
%worst case error occurs for z = 0.5 + i*large

cm= [ .99999999999999999997;
     -.99999999999999999821;
      .99999999999999994183;
     -.99999999999999875788;
      .99999999999998040668;
     -.99999999999975652196;
      .99999999999751767484;
     -.99999999997864739190;
      .99999999984183784058;
     -.99999999897537734890;
      .99999999412319859549;
     -.99999996986230482845;
      .99999986068828287678;
     -.99999941559419338151;
      .99999776238757525623;
     -.99999214148507363026;
      .99997457616475604912;
     -.99992394671207596228;
      .99978893483826239739;
     -.99945495809777621055;
      .99868681159465798081;
     -.99704078337369034566;
      .99374872693175507536;
     -.98759401271422391785;
      .97682326283354439220;
     -.95915923302922997013;
      .93198380256105393618;
     -.89273040299591077603;
      .83945793215750220154;
     -.77148960729470505477;
      .68992761745934847866;
     -.59784149990330073143;
      .50000000000000000000;
     -.40215850009669926857;
      .31007238254065152134;
     -.22851039270529494523;
      .16054206784249779846;
     -.10726959700408922397;
      .68016197438946063823e-1;
     -.40840766970770029873e-1;
      .23176737166455607805e-1;
     -.12405987285776082154e-1;
      .62512730682449246388e-2;
     -.29592166263096543401e-2;
      .13131884053420191908e-2;
     -.54504190222378945440e-3;
      .21106516173760261250e-3;
     -.76053287924037718971e-4;
      .25423835243950883896e-4;
     -.78585149263697370338e-5;
      .22376124247437700378e-5;
     -.58440580661848562719e-6;
      .13931171712321674741e-6;
     -.30137695171547022183e-7;
      .58768014045093054654e-8;
     -.10246226511017621219e-8;
      .15816215942184366772e-9;
     -.21352608103961806529e-10;
      .24823251635643084345e-11;
     -.24347803504257137241e-12;
      .19593322190397666205e-13;
     -.12421162189080181548e-14;
      .58167446553847312884e-16;
     -.17889335846010823161e-17;
      .27105054312137610850e-19];

cm=flipud(cm).'; % sum from small to big 
nmax=size(cm,2);
n=(1:k:k*nmax)';
n=flipud(n);
% z is a  LR vector
% n is an UD vector
[Z,N]=meshgrid(z,n);

% this can take a LOT of memory
f=cm*(N.^-Z);
% but it's really fast to form the series expansion N.^-Z
% and then sum it by an inner product cm*()  :)

%reflect across 1/2
if ~isempty(L)
    zz=z(L);
    if k==1
    % Eta function reflection
    % for test: deta(1,1) should = log(2)
      t=(2-2.^(zz+1))./(2.^zz-2)./pi.^zz;
      f(L)=t.*cos(pi/2*zz).*gamma(zz).*f(L);
      if ~isempty(iszero)
         f(iszero)=0.5;
      end
      if ~isempty(iseven)
         f(iseven)=0;
      end
    end
    if k==2
    % Betad function reflection
    %for test: deta(0,2) should = 0.5
    %for test: deta(1,2) should = pi/4
      f(L)=(2/pi).^zz.*sin(pi/2*zz).*gamma(zz).*f(L);
      if ~isempty(isodd)
         f(isodd)=0;
      end
    end
    if k>2
    % Insert reflection formula for other Dirichlet functions here
      f(L)=(1/pi).^zz.*gamma(zz).*f(L);
      f(L)=NaN;
    end
end

f = reshape(f,sizz);
return

%a demo of this routine is
if 1==2
x=0:1/16:1;
y=0:1/16:32;
[X,Y]=meshgrid(x,y);
z=X+i*Y;
clear X Y
f = deta(z,1);
p=find(abs(f)>5);
if ~isempty(p)
   f(p)=NaN;
end
mesh(x,y,abs(f));
view([83 3]);
axis([0 1 0 32 0 6]);
rotate3d
return
end
