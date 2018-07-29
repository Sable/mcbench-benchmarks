function xyt = Xt(s)

x = s ;

if s <= 0.5
    y = 1-s ;
elseif s>0.5
    y = s ;
end

xyt = [x ; y] ;