function npp=nxtppow(n)
%NXTPPOW Next prime power
%   NPP = NXTPPOW(N) returns an integer NPP greater than ar equal to N.
%   For vectors of length NPP, the FFT procedure is relatively fast.

Matlab_version=version;

nxtexp2=ceil(log2(n));

if nxtexp2<7 | eval(Matlab_version(1))<6
   npp=2^nxtexp2;
else
   if nxtexp2<9
      cand=[72 81 96 108 128 144 162 192 216 256];
   elseif nxtexp2<11
      cand=[288 324 384 432 512 576 648 729 768 864 1024];
   elseif nxtexp2<14
      cand=[1152 1296 1458 1536 1728 2048 2187 2304 2592 2916 3072 3456 4096 4374 4608 5184 5832 6144 6561 6912 8192];
   else
      nxtexp3=ceil(log(n)/log(3));
      cand_exp=[nxtexp3:nxtexp2];
      ne=length(cand_exp);
      cand=zeros(1,0.5*(nxtexp2-nxtexp3+1)*(nxtexp2+nxtexp3+2));
      m=0;
      i=0;
      for k=0:nxtexp3
         cand(m+1:m+ne)=2.^cand_exp*3^i;
         m=m+ne;
         i=i+1;
         cand_exp=cand_exp-1;
      end
      for k=nxtexp3+1:nxtexp2
         cand_exp=cand_exp(2:end);
         ne=ne-1;
         cand(m+1:m+ne)=2.^cand_exp*3^i;
         m=m+ne;
         i=i+1;
         cand_exp=cand_exp-1;
      end
      cand=sort(cand);
   end
   entry=find(cand>=n);
   npp=(cand(entry(1)));
end

%Program history
%======================================================================
%
% Version                Programmer(s)          E-mail address
% -------                -------------          --------------
% [2000 12 30 20 0 0]    W. Wunderink           wwunderink01@freeler.nl
