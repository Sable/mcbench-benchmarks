% 
% 
% Author: Brhanemedhn Tegegne
function out=geterror(PB)
%out=geterror(PB)
%This function takes in the channel bit error probability and returns the
%corresponding error bit probablity in the decoded signal.
G=[[0,1,1;1,0,1;1,1,0;1,1,1],eye(4)];
sig=uint8(wavread('elen849_1.wav')*255);
encoded=linearencode(sig,G);
%Bit error probablity
%PB=0.01;
H=[eye(3),transpose([0,1,1;1,0,1;1,1,0;1,1,1])];
ChannelError=rand(size(encoded))<=PB;
CorruptedSig7bits=xor(ChannelError,encoded);

%Calculating the Syndrome ...
Syndromes=Mod2MatMul(CorruptedSig7bits,transpose(H));
%Error Correction ...
Recovered7bit=xor(errorpattern(Syndromes),CorruptedSig7bits);
%Dropping the parity bits ... 
Recovered7bit(:,[4,5,6,7]);
%Converting to integers ...
Recovered=FourBitToInt(Recovered7bit(:,[4,5,6,7]));
channellerror=sum(sum(xor(CorruptedSig7bits,encoded)));
if channellerror==0
    out=0;
else
    out=sum(sum(xor(Recovered7bit,encoded)))/channellerror*PB;
end
end