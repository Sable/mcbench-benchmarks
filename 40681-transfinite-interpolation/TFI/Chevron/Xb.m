function xyb = Xb(s)

x = s ;

if s <= 0.5
    y = -s ;
elseif s>0.5
    y = s-1 ;
end

xyb = [x ; y] ;