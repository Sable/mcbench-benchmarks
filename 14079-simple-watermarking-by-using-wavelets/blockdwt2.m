function [D]=blockdwt2(A,W);

[row,col]=size(A);

Tr=250;
k=0.02;

[ca,ch,cv,cd] = dwt2(A,'db1');
c1 = [ch cv cd];

[h, w] = size(ca');
[m, n] = size(c1');

W=dmg(W,A);


[caa chh cvv cdd]=dwt2(W,'db1');
W=caa;
size(W);

% Adding watermark image.

for i=1:h
    for j=1:w
        if ca(i,j)>Tr
            Ca(i,j)=ca(i,j)+k*W(i,j);   % <--------k*abs(double(c1(i,j)))*W(i,j); de olabilir
        else
            Ca(i,j)=ca(i,j);
        end
    end
end









% CH1=C1(1:h,1:w);
% CV1=C1(1:h,w+1:2*w);
% CD1=C1(1:h,2*w+1:3*w);

D= double( idwt2(Ca,ch, cv, cd,'db1') );