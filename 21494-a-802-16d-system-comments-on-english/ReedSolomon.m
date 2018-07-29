function [out] = ReedSolomon(random,codeRS,Tx);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                       %
%%     Name: ReedSolomon.m                                               %
%%                                                                       %
%%     Description: The Reed-Solomon encoder is realized according to    %
%%      the standard.                                                    %
%%                                                                       %
%%     Parameters:                                                       %
%%      Sequence of bits to endoe with the algorithm.                    %
%%                                                                       %
%%     Result: It gives back the encoded bits according to the need      %
%%      and also following the modulation.                               %
%%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 m = 8;                          % Number of bits per symbol
 n = codeRS(1);                  % Length of the codeword
 k = codeRS(2);                  % Number of information symbols
 
 % To realize the Reed-Solomon code, the information is needed in decimal.

  random = reshape(random,8,length(random)/8)';
  random = bi2de(random,'left-msb');
 
if Tx==1  
    % 36 bytes are needed with a stuffed zero at the end of the vector:
     yk=[random' 0];
     
    % The Galois vector is generated, the generating polynomial of the
    % code. Then the symbols are encoded with Reed-Solomon.
    msg = gf([yk],m); 
    if n==k                      % bypass for BPSK
        codeRS = msg;   
    elseif n~=k
        codeRS = rsenc(msg,n,k);
    end
    out = codeRS.x;
    
elseif Tx==0
    yk = random;            % In the receiver, nothing needs to be completed.
  
    msg = gf([yk],m);           % In this case, the encoding is undone.
    if n==k
        codeRS = yk;
    elseif n~=k
        codeRS = rsdec(msg',n,k);
        codeRS = codeRS.x;
    end
    out = codeRS(1:end-1);
end

% The binary data to continue working:
 out = double (out);
 out = de2bi (out,8,'left-msb');

% Serial the data for the next step.
 out = reshape (out', 1, length(out)*8);

 
