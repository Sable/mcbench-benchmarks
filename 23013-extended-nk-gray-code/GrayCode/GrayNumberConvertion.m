function [ BaseN,Gray ] = GrayNumberConvertion(Value,Base,Digits )

BaseN = zeros( 1,Digits+1 );
Gray  = zeros( 1,Digits+1 );

for i=1:Digits
    BaseN(i) =  mod(( Value / Base^(i-1)),Base );
    Value = Value - BaseN(i);
end

Shift = 0;
for i = (Digits+1):(-1):1
    Gray( i ) = mod( ( BaseN( i ) - Shift ),Base);
    Shift = Shift + Gray(i);
end

end