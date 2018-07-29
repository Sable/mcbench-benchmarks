%%% data randomization

function [data_out] = randomizer(data_in)
D=length(data_in);
State=[1 0 0 1 0 1 0 1 0 0 0 0 0 0 0];  

for k=1:D
    fdB=bitxor(State(14),State(15));
    State=[fdB State(1:end-1)];
    data_out(k,1)=bitxor(data_in(k,1),fdB);
 end
