function result = masconv(a, b)
%Perform convolution of two arbitrary length
%sequences say x = [1 2 3] & y = [4 5 6 7].
%This is the most easily understood program
%of the convolution as it uses the idea of
%simple polynomial multiplication of the two
%vectors to obtain the convolution sum.

% Initializing a temporary two dimensional
% array upon which the final addition will
% be done to get the result.

tmp = zeros(length(a), length(a)+length(b)-1);

% The for loop to replace zero values in the tmp
% array with the values obtained by multiplication
% of the input vectors at desired places to get the
% final polynomial multiplication table.

for m = 1:length(a)
    for n = 1:length(b)
        tmp(m, m+n-1) = a(m)*b(n);
    end
end

% Display the final two dimensional array tmp
% before displaying the result just to show 
% the user how the final array looks like.
% The user may comment it if need be.

tmp

% The sum command of the Matlab has been neatly
% utilized to get the final convolution sum
% instead of using the for loop etc.

result = sum(tmp);

% The results of this program can be compared
% with the built-in function conv.