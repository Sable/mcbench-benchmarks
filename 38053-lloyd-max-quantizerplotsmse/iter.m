clear all
close all
clc

i = 1;
switch i
    case 1 
        load Dat_1.mat
        
    case 2
        load Dat_1.mat
end

N = 10000;
f = 1/N;
iterations = 12;
bits = 3;
levels = 2^bits;
m_max = 3.9;
delta = (2*m_max)/levels;
m = linspace(-m_max, m_max, levels+1);

for i = 1:iterations
    m
    for k = 1:levels
        
        sum=0;
        count=0;
        for j = 1:N
            if m(k) <= X(j) && X(j) < m(k+1)
                count = count + 1;
                sum = sum + X(j);
            end
        end
        
        if count == 0 && k <= levels/2
            v(k) = m(k);
        else
        if count == 0 && k > levels/2
            v(k) = m(k+1);
        else v(k) = sum/count;
        end
        end
        
    end
    
    for k = 2:levels-1
        m(k) = (v(k) + v(k+1))/2;
    end
   v     
end     