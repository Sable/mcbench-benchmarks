

function M=Find_LCM(x)

%%%%%%%%%% This fucntion can find least common multiple between several
%%%%%%%%%% numbers.

temp=x(1);

for i=2:length(x)
     temp=lcm(temp,x(i));
end

M=temp;
