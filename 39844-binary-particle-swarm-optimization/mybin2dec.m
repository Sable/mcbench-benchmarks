function y=mybin2dec(x)

if x==0
    y=0;
else
    l=length(x);
    y=0;
    for i=0:l-1
        y=y+x(i+1)*2^(i);
    end
end