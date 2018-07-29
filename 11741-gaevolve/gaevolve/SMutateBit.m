% The mutation function:
function nnum = SMutateBit(num)

% Selecting a position:
pos = ceil(rand*32);

% Flipping that bit:
change = bitset(0,pos);
nnum = bitxor(num,change);