function y= fcnNormalize0_1(a)
% normalizes matrix between 100 and 0; input, output: matrix
% higheest value = 0; lowest = 100;
% use y= fcnNormalize0_1(-a) for high=100; low=0;



b=[];
for i=1:size(a)
    b = [b a(i,:)]; % converts matrix to a vector
end

n=(b-(min(b)))/max(b-min(b)); % normalizes between 0 and 1
n = abs(n-1);                 % changes the normaliation between 1 and 0
n= n.*100;                      % range = 0 :100


y = vec2mat ( n,(size(a,2))); % converts vector to same size matrix

% *************************************************************************

