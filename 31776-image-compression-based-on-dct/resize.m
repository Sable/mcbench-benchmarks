function [output]=resize(input)
a=abs(input);
b=0;
c=0;
d=0;
e=0;
if a<(2^8)
    b=a;
else
    if a<(2^16)
        b=mod(a,(2^8));
        c=fix(a/(2^8));
    else
        if a<(2^24)
            b=mod(a,(2^8));
            b2=fix(a/(2^8));
            c=mod(b2,(2^8));
            d=fix(b2/(2^8));
        else
           if a<(2^32)
               b=mod(a,(2^8));
               b2=fix(a/(2^8));
               c=mod(b2,(2^8));
               c2=fix(b2/(2^8));
               d=mod(c2,(2^8));
               e=fix(c2/(2^8));
           end
       end
   end
end
A=[b c d e];
output=A;