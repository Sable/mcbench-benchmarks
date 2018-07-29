function  y = mls(n,flag)

%y = mls(n,{flag});
%
%Generates a Maximum Length Sequence of n bits by utilizing a 
%linear feedback shift register with an XOR gate on the tap bits 
%
%Function can accept bit lengths of between 2 and 24
%
%y is a vector of 1's & -1's that is (2^n)-1 in length.
%
%optional flag is:
%
%  1 for an initial sequence of all ones (repeatable)
%  0 for an initial sequence that is random (default)
%
%note: Because of the recursive nature of this process, it is not 
%possible to completely vectorize this code (at least I don't know 
%how to do it). As a result, longer bit lengths will take quite a 
%long time to process, perhaps hours. If you figure out a way to 
%vectorize the for loop, please let me know.
%
%reference:
%	Davies, W.D.T. (June, July, August, 1966). Generation and 
%properties of maximum-length sequences. Control, 302-4, 364-5,431-3.
%
%Spring 2001, Christopher Brown, cbrown@phi.luc.edu

switch n								%assign taps which will yeild a maximum
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
   tap1=2;
   tap2=3;
   tap3=4;
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
   tap1=1;
   tap2=4;
   tap3=6;
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
   tap2=3;
   tap3=5;
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
   tap2=2;
   tap3=5;
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
%case 25
%   taps=2;
%   tap1=3;
%   tap2=25;
%case 26
%   taps=4;
%   tap1=1;
%   tap2=7;
%   tap3=8;
%   tap4=26;
%case 27
%   taps=4;
%   tap1=1;
%   tap2=7;
%   tap3=8;
%   tap4=27;
%case 28
%   taps=2;
%   tap1=3;
%   tap2=28;
%case 29
%   taps=2;
%   tap1=2;
%   tap2=29;
%case 30
%   taps=4;
%   tap1=1;
%   tap2=15;
%   tap3=16;
%   tap4=30;
%case 31
%   taps=2;
%   tap1=3;
%   tap2=31;
%case 32
%   taps=4;
%   tap1=1;
%   tap2=27;
%   tap3=28;
%   tap4=32;
otherwise
   disp(' ');
   disp('input bits must be between 2 and 24');
   return
end

if (nargin == 1) 
	flag = 0;
end

if flag == 1
	abuff = ones(1,n);
else
	rand('state',sum(100*clock))
	
	while 1
		abuff = round(rand(1,n));
		%make sure not all bits are zero
		if find(abuff==1)
			break
		end
	end
end

for i = (2^n)-1:-1:1
      
   xorbit = xor(abuff(tap1),abuff(tap2));		%feedback bit
   
   if taps==4
      xorbit2 = xor(abuff(tap3),abuff(tap4));%4 taps = 3 xor gates & 2 levels of logic
      xorbit = xor(xorbit,xorbit2);				%second logic level
   end
   
	abuff = [xorbit abuff(1:n-1)];
	y(i) = (-2 .* xorbit) + 1;  	%yields one's and negative one's (0 -> 1; 1 -> -1)
end
