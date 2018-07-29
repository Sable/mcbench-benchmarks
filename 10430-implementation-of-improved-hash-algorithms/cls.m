function output = cls(input,amount)
output = input;

for jj = 1:amount
   output = [ output([2:32]), output(1)];
end        