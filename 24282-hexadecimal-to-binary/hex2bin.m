function bin=hex2bin(x)
hex=x;
for i=1:length(hex)
    if hex(i)=='f'
        bin((i*4)-3:i*4)=[1 1 1 1];
    elseif hex(i)=='e'
        bin((i*4)-3:i*4)=[1 1 1 0];
    elseif hex(i)=='d'
        bin((i*4)-3:i*4)=[1 1 0 1];
    elseif hex(i)=='c'
        bin((i*4)-3:i*4)=[1 1 0 0];
    elseif hex(i)=='b'
        bin((i*4)-3:i*4)=[1 0 1 1];
    elseif hex(i)=='a'
        bin((i*4)-3:i*4)=[1 0 1 0];
    elseif hex(i)=='9'
        bin((i*4)-3:i*4)=[1 0 0 1];
    elseif hex(i)=='8'
        bin((i*4)-3:i*4)=[1 0 0 0];
    elseif hex(i)=='7'
        bin((i*4)-3:i*4)=[0 1 1 1];
    elseif hex(i)=='6'
        bin((i*4)-3:i*4)=[0 1 1 0];
    elseif hex(i)=='5'
        bin((i*4)-3:i*4)=[0 1 0 1];
    elseif hex(i)=='4'
        bin((i*4)-3:i*4)=[0 1 0 0];
    elseif hex(i)=='3'
        bin((i*4)-3:i*4)=[0 0 1 1];
    elseif hex(i)=='2'
        bin((i*4)-3:i*4)=[0 0 1 0];
    elseif hex(i)=='1'
        bin((i*4)-3:i*4)=[0 0 0 1];
    elseif hex(i)=='0'
        bin((i*4)-3:i*4)=[0 0 0 0];
    end
end  