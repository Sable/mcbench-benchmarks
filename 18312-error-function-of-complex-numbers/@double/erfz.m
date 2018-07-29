%Error function of complex numbers.
%
%Synopsis:
%
%  e=erfz(z)
%     Error function of the complex numbers z.
%
%Comments:
%
%  This is a companion implementation of the reference
%  implementation as MEX-function. An overview on the
%  implemented algorithm is documented in "erfz.pdf".

% [1] Abramowitz M. and Stegun I.A. (ed.),
%     "Handbook of Mathematical Functions,"
%     New York: Dover (1972).

%     Marcel Leutenegger © January 2008
%
function e=erfz(z)
if isempty(z)
   e=z;
elseif isreal(z)
   e=erf(z);
else
   R=real(z);
   I=imag(z);
   e=repmat(nan,size(z));
   n=isfinite(R) + 2*isfinite(I);
   %
   % n  ->>  e
   %
   % 0      nan
   % 1      nan
   % 2      erf(R)
   % 3      erf(R) + parts(R,I)
   %
   k=n >= uint8(2);
   e(k)=erf(R(k));
   n=n == uint8(3) & I ~= uint8(0);
   if any(n(:))
      I=I(n);
      R=R(n);
      R=parts(R,abs(I));
      k=I < uint8(0);
      R(k)=conj(R(k));
      e(n)=e(n) + R;
   end
end


%Evaluate all partial functions E(z) to G(z).
%
%Because of the comparably large overhead for comparison
%and sub-indexing, this MATLAB implementation calculates
%simply all sub-functions regardless of the significance
%for the result.
%
% R      Real part
% I      Imaginary part
% e      Total result
%
function e=parts(R,I)
R2=R.*R;
e2iRI=exp(complex(0,-2*R.*I));
E=(1 - e2iRI)./(2*pi*R);
E(~R)=0;
F=0;
Hr=0;
Hi=0;
N=sqrt(1 - 4*log(eps/2));
for n=1:ceil(N)
   H=n*n/4;
   H=exp(-H)./(H + R2);
   F=F + H;
   H=H.*exp(-n*I);
   Hi=Hi + n/2*H;
   Hr=Hr + H;
end
e=exp(-R2).*(E + R.*F/pi - e2iRI.*complex(R.*Hr,Hi)/(2*pi));
clear('E','F','H*');
R3=R2 + log(2*pi);
Gr=0;
Gi=0;
M=2*I;
n=max(1,floor(M - N));
M=ceil(max(M + N - n));
for m=0:M
   n1=n/2;
   n2=n1.*n1;
   G=exp(n.*I - n2 - R3 - log(n2 + R2));
   Gi=Gi - n1.*G;
   Gr=Gr + G;
   n=n + 1;
end
e=e - e2iRI.*complex(R.*Gr,Gi);
n=R == uint8(0);
e(n)=e(n) + complex(0,I(n)./pi);
