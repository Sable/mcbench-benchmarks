function pilot_mapping = generatepilot (n_symbol,Tx)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                       %
%%      Name: generatepilot.m                                            %
%%                                                                       %
%%      Description: A vector is generated which indicates the carrier   %
%%       frequencies of the pilot, as well as another vector in which    %
%%       these carriers are modulated according to the standard.         % 
%%                                                                       %
%%      Result: It gives back 2 vectors                                  %
%%       --> One indicates the absolute positions of the pilot carriers  %
%%           throughout the OFDM symbol.                                 %
%%       --> Another one carries the values of the pilots, already       %
%%           modulated.                                                  %
%%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% The values of the pilots are to be modulated on to the carriers. These
% are defined in the standard as such(pp 443) :

% Before beginning, it is necessary to consider that the value to calculate
% depends on 2 factors : the number of symbols and whether we are in the
% uplink or dwnlink. We will consider that we are in the downlink and we
% are transmitting the symbol "1". If we want to consider the other
% connection, the seed would be "10101010101".

seed = [1 1 1 1 1 1 1 1 1 1 1];

for i=1:n_symbol+2                         
    wk(i) = seed (11);                   
    next = xor(seed(9),seed(11));
    seed = [next seed(1,1:10)];
end

% Once the value of wk is found(that depends on the number of symbol with
% wihich it is working), the values of the subcarriers must be found and of
% the mapping of them with BPSK constellation.

wk = wk(n_symbol+2);

A = 1 - wk;                                 % Values defined in the standard.
B = 1 - (~wk);
value_carrier = [A B A B B B A A];

% For uplink, the values should be [A B A B A A A A]

pilot_mapping = 2*mapping(value_carrier,1,Tx);      

% The factor of "2" is due to the fact that the pilots are transmitted to a
% double power of the information bits.


