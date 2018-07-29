function [ GrayCode,GrayCodeLength ] = GenerateGrayCode( Range )
% Range is the maximum states of each digit.
Digit= size( Range,2 );% Digit is the number of digits
if Digit == 1
    GrayCode = 0; GrayCodeLength = 1;
    return
end
GrayCodeLength = prod( Range );
GrayCode = zeros( GrayCodeLength,Digit);
Range = [ Range,Range( Digit )];
Gray = zeros(1,Digit+1);  % store the generated gray code
Direction = ones(1,Digit+1);  % +1 or -1

t = 1;
while Gray(Digit+1)==0
    GrayCode(t,:)= Gray( 1:Digit);
    t = t + 1;  i = 1;
    k = Gray(1)+Direction(1);
    while( k >= Range(i)) || k <0
        Direction(i) = -Direction(i);
        i = i + 1; k = Gray(i) + Direction(i);
    end
    Gray(i) = k;
end

end