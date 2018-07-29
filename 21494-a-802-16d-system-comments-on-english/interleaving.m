function [data_interleave] = interleaving(data_convolutional,Ncpc,Tx);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                       %
%%     Name: interleaving.m                                              %
%%                                                                       %
%%     Description: This process is for interleave the bits to transmit  %
%%      and to make sure two consecutive bits are not modulated to       %
%%      the same frequency. It is another form to fight against          %
%%      frequency selective fading and burst errors.                     %
%%                                                                       %
%%                                                                       %
%%     Parameters:                                                       %
%%      Sequence of bits to interleave.                                  %
%%                                                                       %
%%     Result: It gives back the chain of bits, properly interleaved.    %
%%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% The size of the block to use to interleave the sequence is needed.
% This value is taken from table 223 of the standard.
% The value of the used block depends on the mapping that we want.

switch Ncpc
    case 1                          % for BPSK
        Ncbps=192; 
    case 2                          % for QPSK
        Ncbps=384; 
    case 4                          % for 16-QAM
        Ncbps=768; 
    case 6                          % for 64-QAM
        Ncbps=1152; 
end

s=ceil(Ncpc/2);

if Tx==1
  % In the following operations, it is necessary to consider the following values:
  % k-->index of the bit encoded BEFORE the first permutation
  % mk-->index of this bit BEFORE the second permutation and AFTER the first one
  % jk-->index after the SECOND permutation, just before the mapping of the sign.

    k = 0:Ncbps-1;
    mk = ((Ncbps/12)*mod(k,12))+floor(k/12);                     % First permutation
    jk = s*floor(mk/s)+mod(mk+Ncbps-floor(12*mk/Ncbps),s);       % Second permutation

    % Now I must arrange the indices to know in what order I must take the bits of the entering sequence. 
    [a c] = sort(jk);

elseif Tx==0
  % Again, it is necessary to understand the values:
  % j-->index of the bit encoded BEFORE the first permutation
  % mj-->index of this bit BEFORE the second permutation and AFTER the first one
  % kj-->index after the SECOND permutation, just before the mapping of the sign.

    j = 0:Ncbps-1;
    mj = s*floor(j/s) + mod((j + floor(12*j/Ncbps)),s);          % First permutation
    kj = 12*mj-(Ncbps-1)*floor(12*mj/Ncbps);                     % Second permutation
    
    % The indices are ordered to know what must be taken.
    [a c]= sort(kj);

end

% finally the bits are rearranged.

 i = 1:Ncbps-1;
 data_interleave = zeros(1,Ncbps);
 data_interleave(i) = data_convolutional(c(i));


