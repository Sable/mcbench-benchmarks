function  [mls,row,col] = mls(n)

%[mls,row,col] = mls(n);
%
%Generates a Maximum Length Sequence of n bits by utilizing a 
%linear feedback shift register with an XOR gate on the tap bits
%Also given are the permutation vector row and col, used by prior and after
%the autocorreltion calculation via FHT.
%
%Function can accept bit lengths of between 2 and 24
%
%y is a vector of 1's & -1's that is (2^n)-1 in length.
%
%reference:
%	Davies, W.D.T. (June, July, August, 1966). Generation and 
%properties of maximum-length sequences. Control, 302-4, 364-5,431-3.
%
%Spring 2001, Christopher Brown, cbrown@phi.luc.edu

switch n							%assign taps which will yeild a maximum
case 2								%length sequence for a given bit length
   taps=2;							%I forget the reference I used, but theres
   tap1=1;							%a list of appropriate tap values in
   tap2=2;							%Vanderkooy, JAES, 42(4), 1994.
case 3
   taps=2;
   tap1=1;
   tap2=3;
case 4
   taps=2;
   tap1=1;
   tap2=4;
case 5
   taps=2;
   tap1=2;
   tap2=5;
case 6
   taps=2;
   tap1=1;
   tap2=6;
case 7
   taps=2;
   tap1=1;
   tap2=7;
case 8
   taps=4;
   tap1=1;
   tap2=5;
   tap3=6;
   tap4=8;
case 9
   taps=2;
   tap1=4;
   tap2=9;
case 10
   taps=2;
   tap1=3;
   tap2=10;
case 11
   taps=2;
   tap1=2;
   tap2=11;
case 12
   taps=4;
   tap1=3;
   tap2=4;
   tap3=7;
   tap4=12;
case 13
   taps=4;
   tap1=1;
   tap2=3;
   tap3=4;
   tap4=13;
case 14
   taps=4;
   tap1=1;
   tap2=11;
   tap3=12;
   tap4=14;
case 15
   taps=2;
   tap1=1;
   tap2=15;
case 16
   taps=4;
   tap1=2;
   tap2=3;
   tap3=5;
   tap4=16;
case 17
   taps=2;
   tap1=3;
   tap2=17;
case 18
   taps=2;
   tap1=7;
   tap2=18;
case 19
   taps=4;
   tap1=1;
   tap2=5;
   tap3=6;
   tap4=19;
case 20
   taps=2;
   tap1=3;
   tap2=20;
case 21
   taps=2;
   tap1=2;
   tap2=21;
case 22
   taps=2;
   tap1=1;
   tap2=22;
case 23
   taps=2;
   tap1=5;
   tap2=23;
case 24
   taps=4;
   tap1=1;
   tap2=3;
   tap3=4;
   tap4=24;
case 25
  taps=2;
  tap1=3;
  tap2=25;
case 26
  taps=4;
  tap1=1;
  tap2=7;
  tap3=8;
  tap4=26;
case 27
  taps=4;
  tap1=1;
  tap2=7;
  tap3=8;
  tap4=27;
case 28
  taps=2;
  tap1=3;
  tap2=28;
case 29
  taps=2;
  tap1=2;
  tap2=29;
case 30
  taps=4;
  tap1=1;
  tap2=15;
  tap3=16;
  tap4=30;
case 31
  taps=2;
  tap1=3;
  tap2=31;
case 32
  taps=4;
  tap1=1;
  tap2=27;
  tap3=28;
  tap4=32;
otherwise
   disp(' ');
   error('input bits must be between 2 and 32');
end

if taps == 2
    [mls,row,col]=mls2tap(tap2,tap1,tap2);
elseif taps == 4
    [mls,row,col]=mls4tap(tap4,tap1,tap2,tap3,tap4);
end

