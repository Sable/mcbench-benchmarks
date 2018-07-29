function y=bit2num(th_bit,b,thetmin,thetmax)
% J. C. Spall, August 1999
% For the relevant element of theta (say, the jth), this function converts bit 
% representation to floating point no. with M(j) 
% decimal places of accuracy (the M vector used in GAbit_roulette).  
%           
y=0;
for i=1:b
   y=y+th_bit(b+1-i)*2^(i-1);
end
y=thetmin+(thetmax-thetmin)*y/(2^b-1);