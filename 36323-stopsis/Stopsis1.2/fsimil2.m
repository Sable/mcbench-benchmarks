function [Simil2]=fuzzysimil2(A,B)

PA=sqrt((A(1)-A(2))^2+A(5)^2)+sqrt((A(3)-A(4))^2+A(5)^2)+(A(3)-A(2))+(A(4)-A(1));
PB=sqrt((B(1)-B(2))^2+B(5)^2)+sqrt((B(3)-B(4))^2+B(5)^2)+(B(3)-B(2))+(B(4)-B(1));
aA=1/2*(A(5)*(A(3)-A(2)+A(4)-A(1)));
aB=1/2*(B(5)*(B(3)-B(2)+B(4)-B(1)));
temp=(min(PA,PB)/max(PA,PB))*(min(aA,aB) + min(A(5),B(5)))/(max(aA,aB) + max(A(5),B(5)));

Simil2=(1-(sum(abs(A(1:4)-B(1:4))))/4)*temp;

