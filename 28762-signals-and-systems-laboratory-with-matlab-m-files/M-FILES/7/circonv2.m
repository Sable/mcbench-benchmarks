% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
% problem 8 - This function computes the circular convolution of two sequences
% that may not have the same number of samples


function y=circonv2(x,h)

N1=length(x);
N2=length(h);
N=max(N1,N2);

 if  N>N1
  x=[x  zeros(1,N-length(x))];
 end

if N> N2 
  h=[h  zeros(1,N-length(h))];
end

 for m=0:N-1
p(m+1)=mod(-m,N);
hs(1+m)=h(1+p(m+1));
 end

 for n=0:N-1
    hsn=circshift(hs',n);
    y(n+1)=x*hsn;
end
