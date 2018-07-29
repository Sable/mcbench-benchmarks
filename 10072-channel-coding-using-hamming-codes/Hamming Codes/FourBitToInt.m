%FourBitToInt.m
function out=FourBitToInt(FourBitMatrix)
%Takes a binary matrix of 4 columns and any even number of rows and
%constructs a column matrix by creating an integer by concatenating two 
%consecutive rows in FourBitMatrix to form an 8 bit binary number and then
%converting that to a decimal. 
%Author: Brhanemedhn Tegegne
%
    [r,c]=size(FourBitMatrix);
    out=uint8(zeros(r/2,1));
    for i=1:r/2
        for j=1:4
             out(i)=out(i)+FourBitMatrix(2*i-1,j)*2^(8-j);
             out(i)=out(i)+FourBitMatrix(2*i,j)*2^(4-j);
        end
    end
end
