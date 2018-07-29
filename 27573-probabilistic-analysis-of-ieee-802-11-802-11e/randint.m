%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = randint(a,b,number)

% generates integers taken from the discrete uniform distribution
% defined on the interval a to b, a<b, as column

% rand('state',sum(100*clock))  %resetting the random numbers generator to different state each time

out = rand(number,1);       %uniform distribution from 0 to 1
out = out*(b-a+1);          %uniform distribution from 0 to (b-a+1)
out = ceil(out);            %integers with uniform distribution from 0 to (b-a+1)
out = out + a-1;            %integers with uniform distribution from a to b