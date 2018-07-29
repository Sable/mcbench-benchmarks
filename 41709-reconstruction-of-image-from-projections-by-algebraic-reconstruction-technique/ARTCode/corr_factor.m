function [rsumG,csumG,padGIMG]=corr_factor(padGIMG,rowsizeG,rsumO,csumO,r3,c3,s,z)
for k = 1:s,
[rsumG,csumG]=calc_sum(padGIMG,rowsizeG,z);
X = rsumO - rsumG;
Y = csumO - csumG;
    for i= 1:r3, 
        for j= 1:c3,
            c(i,j)= X(i)/2 + Y(j)/2;
            padGIMG(i,j) = padGIMG(i,j) + c(i,j);
        end
    end
end