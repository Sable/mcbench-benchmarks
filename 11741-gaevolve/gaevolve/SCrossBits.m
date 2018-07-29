% The crossing function:
function nnum = SCrossBits(num1,num2)

% Selecting a position:
pos = ceil(rand*32);

% The output:
nnum = 0;

% Setting the first bits:
for ind=1:pos
    if bitget(num1,ind)==1
        nnum = bitset(nnum,ind);
    end
end

% Setting the other bits:
for ind=pos+1:32
    if bitget(num2,ind)==1
        nnum = bitset(nnum,ind);
    end
end
