function out=Mod2MatMul(matr1,matr2)
%out=Mod2MatMul(matr1,matr2)
%Finds a modulo 2 based matrix product of binary matrices (matr1 & matr2)

%Author: Brhanemedhn Tegegne
%
[r1,c1]=size(matr1);
[r2,c2]=size(matr2);
if c1~=r2 
    'Non Matching Matrices'
else
    out=zeros(r1,c2);
    for i=1:r1
        for j=1:c2
            for k=1:c1
                out(i,j)=xor(out(i,j),matr1(i,k)*matr2(k,j));
            end
        end
    end
end
end
