% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
% problem 4 - This function computes the circular convolution of two sequences
% that have the same number of samples


function y=circonv(x,h)

N=length(x);

 for  m=0:N-1
hs(1+m)=h(1+mod(-m,N));
 end
 
  for n=0:N-1
   hsn=circshift(hs',n);
    y(n+1)=x*hsn;
end
