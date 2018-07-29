function x = isodd (number)

% isodd(number)
%
% returns 1 if the number is Odd, 0 if it is even.

% Divide input by 2:

a = number/2;
whole = floor(a);
part = a-whole;

if part > 0;
    
    x = 1;
    
else
    
    x = 0;
    
end