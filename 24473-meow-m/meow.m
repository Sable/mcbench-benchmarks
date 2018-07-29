function meow(n, paws)
%
% This Matlab function plays n successive cat meows, where each of the n
% meows is randomly chosen from one of two available sounds.  The function
% pauses for paws seconds after each meow.  The default values of n and
% paws are 5 and 3, respectively.
%
% Dr. Phillip M. Feldman   18 June, 2009

if nargin<1, n= 5; end
if nargin<2, paws= 3; end

for i= 1 : n
   if (rand(1) <= 0.5)
      infile= 'meow1.wav';
   else
      infile= 'meow2.wav';
   end

   [Y,Fs,Nbits]= wavread(infile);
   sound(Y, Fs);
   pause(paws);
end
