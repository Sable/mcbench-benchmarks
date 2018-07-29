function ue= f_ptos(signal1)
%  function to be used in the ptos program
% k1=100;%  N=1;
Na=signal1(1);
k1=signal1(2);
e=signal1(3);
k2=sqrt(2*k1/Na);
if  abs(e)<=1/k1
     ue=(k1/k2)*e;
else 
    ue=sign(e)*(sqrt(2*Na*abs(e))- 1/k2);
end
