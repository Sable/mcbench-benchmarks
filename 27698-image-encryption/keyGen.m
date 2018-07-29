function [key] = keyGen(n)
n = n*8;
% n = 2048*2048*16;
% n = 24 * 24 * 8;
bin_x = zeros(n,1,'uint8');
r = 3.9999998;
bin_x_N_Minus_1 =  0.300001;
x_N = 0;
tic
for ind = 2 : n
    x_N = 1 - 2* bin_x_N_Minus_1 * bin_x_N_Minus_1;    
     if (x_N > 0.0)
        bin_x(ind-1) = 1;
    end 
     bin_x_N_Minus_1 =  x_N;
     
end
toc
% save bin_sec bin_x;
t = uint8(0);
key = zeros(n/8,1,'uint8');
for ind1 = 1 : n/8
    
    for ind2 = 1 : 8
    key(ind1) = key(ind1) + bin_x(ind2*ind1)* 2 ^ (ind2-1);
    end
      
end