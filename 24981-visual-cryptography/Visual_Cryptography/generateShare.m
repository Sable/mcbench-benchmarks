%Program for random permuting the share generation

%Author : Athi Narayanan S
%M.E, Embedded Systems,
%K.S.R College of Engineering
%Erode, Tamil Nadu, India.
%http://sites.google.com/site/athisnarayanan/
%s_athi1983@yahoo.co.in

%Program Description
%This program generates the share 1 & share 2 randomly for each pixel. 

function out = generateShare(a,b)

a1 = a(1);
a2 = a(2);
b1 = b(1);
b2 = b(2);

in = [a
      b];
out = zeros(size(in));
randNumber = floor(1.9*rand(1));

if (randNumber == 0)
    out = in;
elseif (randNumber == 1)
    a(1) = a2;
    a(2) = a1;
    b(1) = b2;
    b(2) = b1;
    out = [a
           b];   
end