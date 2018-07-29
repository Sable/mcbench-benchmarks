function [f1,f2,DialedNum] = DecodedFrequencies(E);

%Computes the energy of the Signal
%Input Variables
%    E    = Energy Matrix of the Filtered Signals
%
% Output Variables
%    f1   = first decoded frequency 
%    f2   = second decoded frequency

Fmat = [697 770 852 941 1209 1336 1477 1633];

LowEnergyMatrix = E(1:4);
HighEnergyMatrix = E(5:8);

[e1,e1Index]=max(LowEnergyMatrix);
[e2,e2Index]=max(HighEnergyMatrix);

f1 = Fmat(e1Index);
f2 = Fmat(4+e2Index);

if        f1 == Fmat(1) && f2 == Fmat(5) 
   DialedNum = '1';
   elseif f1 == Fmat(1) && f2 == Fmat(6) 
   DialedNum = '2';
   elseif f1 == Fmat(1) && f2 == Fmat(7) 
   DialedNum = '3';
   elseif f1 == Fmat(1) && f2 == Fmat(8) 
   DialedNum = 'A';
   elseif f1 == Fmat(2) && f2 == Fmat(5) 
   DialedNum = '4';
   elseif f1 == Fmat(2) && f2 == Fmat(6) 
   DialedNum = '5';
   elseif f1 == Fmat(2) && f2 == Fmat(7) 
   DialedNum = '6';
   elseif f1 == Fmat(2) && f2 == Fmat(8) 
   DialedNum = 'B';
   elseif f1 == Fmat(3) && f2 == Fmat(5) 
   DialedNum = '7';
   elseif f1 == Fmat(3) && f2 == Fmat(6) 
   DialedNum = '8';
   elseif f1 == Fmat(3) && f2 == Fmat(7) 
   DialedNum = '9';
   elseif f1 == Fmat(3) && f2 == Fmat(8) 
   DialedNum = 'C';
   elseif f1 == Fmat(4) && f2 == Fmat(5) 
   DialedNum = '*';
   elseif f1 == Fmat(4) && f2 == Fmat(6) 
   DialedNum = '0';
   elseif f1 == Fmat(4) && f2 == Fmat(7) 
   DialedNum = '#';
   elseif f1 == Fmat(4) && f2 == Fmat(8) 
   DialedNum = 'D';
else
    DialedNum = 'p';
end
