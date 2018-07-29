% Rounds a scalar, matrix or vector to a specified number of decimal places
% Format is roundoff(number,decimal_places)

function y = roundoff(number,decimal_places)

[INeg,JNeg] = find( number<0 ); % Negative numbers

if ~isempty(INeg)
   IndNeg = sub2ind(size(number),INeg,JNeg);
   Number = abs(number);
else
   Number = number;
end

decimals = 10.^decimal_places;
y1 = fix(decimals * Number + 0.5)./decimals;

if ~isempty(INeg)
   y1(IndNeg) = -y1(IndNeg);
end

y = y1;