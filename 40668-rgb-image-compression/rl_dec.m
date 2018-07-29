function x=rl_dec(d,c);

% This function performs Run Length Dencoding to the elements of the strem 
% of data d according to their number of apperance given in c. There is no 
% restriction on the format of the elements of d, while the elements of c 
% must all be integers.
% This function is built by Abdulrahman Ikram Siddiq in Oct-1st-2011 5:36pm.
 
if nargin<2
    error('not enough number of inputs')
end

x=[];
for i=1:length(d)
x=[x d(i)*ones(1,c(i))];
end