% A main script to test the functions..
% 
% 
% Author: Brhanemedhn Tegegne

G=[[0,1,1;1,0,1;1,1,0;1,1,1],eye(4)];
sig=uint8(wavread('elen849_1.wav')*255);
%Play the original speech
wavplay(sig,8000);
%Plot the original speech
subplot(2,2,1),plot(sig);
title('Orginal Speech');

encoded=linearencode(sig,G);
%Bit error probablity
PB=0.01;
H=[eye(3),transpose([0,1,1;1,0,1;1,1,0;1,1,1])];
ChannelError=rand(size(encoded))<=PB;
CorruptedSig7bits=xor(ChannelError,encoded);
%Plot the Corrupted signal without encoding
%encoded(:,[5,6,7,8])-

Corrupted4bit=CorruptedSig7bits(:,[4,5,6,7]);
%sum(encoded(:,[5,6,7,8])-Corrupted4bit)
Corrupted=FourBitToInt(Corrupted4bit);
%Plot the corrupted speech
subplot(2,2,2),plot(Corrupted);
title('Corrupted Speech - by just ignoring the parity bits');
%play the corrupted signal - without encoding/decoding
wavplay(uint8(Corrupted),8000);

%Calculating the Syndrome ...
Syndromes=Mod2MatMul(CorruptedSig7bits,transpose(H));
%Error Correction ...
Recovered7bit=xor(errorpattern(Syndromes),CorruptedSig7bits);
%Dropping the parity bits ... 
Recovered4bit=Recovered7bit(:,[4,5,6,7]);
%Converting to integers ...
Recovered=FourBitToInt(Recovered4bit);

%Plot the recovered speech
subplot(2,2,3),plot(Recovered);
title('Recovered speech - after linear block encoding and decoding');
%play the corrupted signal - without encoding/decoding
wavplay(uint8(Recovered),8000);


