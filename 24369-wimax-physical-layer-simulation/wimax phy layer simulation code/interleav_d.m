% Interleaver function
function [data_out]=interleav_d(data_in,rate_id)

switch (rate_id)
    case 0
       Ncbps=192;  % In BPSK no.of bits allocated to subcarrier in a OFDM symbol
       Ncpc=1;     % In cash of BPSK No. of coded bit per carrier.
    case {1,2}
      Ncbps=384;  
      Ncpc=2;         
    case {3,4}     %% note: no. of coded bit Ncpc=1,2,4,6 for bpsk,qpsk,16qam,64qam respectivly%%         
       Ncbps=768;  
       Ncpc=4;    
    case {5,6}                                 
       Ncbps=1152;  
       Ncpc=6;     
    otherwise
       display('error in interleaver give proper rate_id')
end

s=ceil(Ncpc/2);

data=data_in';
  % k-->index of the bit encoded BEFORE the first permutation
  % mk-->index of this bit BEFORE the second permutation and AFTER the first one
  % jk-->index after the SECOND permutation, just before the mapping of the
  % signal.

 
 k=0:Ncbps-1;
 mk = ((Ncbps/12)*mod(k,12))+floor(k/12);                     % First permutation
 jk = s*floor(mk/s)+mod(mk+Ncbps-floor(12*mk/Ncbps),s);       % Second permutation

    
 % Now I must arrange the indices to know in what order I must take the bits of the entering sequence. 
 [a b] = sort(jk);

    
% % finally the bits are rearranged.

 i = 1:Ncbps;
 data_out = zeros(1,Ncbps);
 data_out(i) = data(b(i));
 data_out=data_out';
 
 