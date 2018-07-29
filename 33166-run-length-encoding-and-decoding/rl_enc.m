function [d,c]=my_RLE(x);
% This function performs Run Length Encoding to a strem of data x. 
% [d,c]=rl_enc(x) returns the element values in d and their number of
% apperance in c. All number formats are accepted for the elements of x.
% This function is built by Abdulrahman Ikram Siddiq in Oct-1st-2011 5:15pm.

if nargin~=1
    error('A single 1-D stream must be used as an input')
end

ind=1;
d(ind)=x(1);
c(ind)=1;

for i=2 :length(x)
    if x(i-1)==x(i)
       c(ind)=c(ind)+1;
    else ind=ind+1;
         d(ind)=x(i);
         c(ind)=1;
    end
end