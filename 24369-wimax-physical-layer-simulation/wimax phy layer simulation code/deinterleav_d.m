% DeInterleaver function
function [data_out]=deinterleav_d(data_in,rate_id)

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
%%% Deinterleaving 
  % j-->index of the bit encoded BEFORE the first permutation
  % mj-->index of this bit BEFORE the second permutation and AFTER the first one
  % kj-->index after the SECOND permutation, just before the mapping of the sign.

  j = 0:Ncbps-1;
  mj = s*floor(j/s) + mod((j + floor(12*j/Ncbps)),s);          % First permutation
  kj = 12*mj-(Ncbps-1)*floor(12*mj/Ncbps);                     % Second permutation
    
  % The indices are ordered to know what must be taken.
  [c d]= sort(kj);

% finally the bits are rearranged.

 i = 1:Ncbps;
 data_out = zeros(1,Ncbps);
 data_out(i) = data(d(i));
 data_out=data_out';
 