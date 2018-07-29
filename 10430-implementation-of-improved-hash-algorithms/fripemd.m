function output = fripemd (t,side,b,c,d)
% Performs the f function as follows
%
%     |  (x and y) xor (x' and z)               t=0 to t=19  
%     |  (x) xor (y) xor (z)                    t=20 to t=39
% f = |  (x and y) xor (x and z) xor (y and z)  t=40 to t=59
%     |  (x) xor (y) xor (z)                    t=60 to t=79
%     
% t=60;x=1;y=0;z=0;
if side=='L'
    if t <= 16
   output = xor(xor(b,c),d);
elseif t <= 32
   output = (b&c)|(~b&d);
elseif t <= 48
    output = xor((b&~c),d);
elseif t <= 64
    output = (b&d)|(c&~d);
elseif  t<=80
    output=xor(b,c|~d);
else
    error ('t must be in the range 1 to 80');
end
end
if side=='R'
    if t <= 16
 output=xor(b,c|~d);
elseif t <= 32
    output = (b&d)|(c&~d);
elseif t <= 48
    output = xor((b&~c),d);
elseif t <= 64
   output = (b&c)|(~b&d);
elseif  t<=80
   output = xor(xor(b,c),d);
else
    error ('t must be in the range 1 to 80');
end
end








