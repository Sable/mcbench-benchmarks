
function [Simil] = fsimil1(A,B)

P_A=sqrt((A(1)-A(2))^2+A(5)^2)+sqrt((A(3)-A(4))^2+A(5)^2)+(A(3)-A(2))+(A(4)-A(1));
P_B=sqrt((B(1)-B(2))^2+B(5)^2)+sqrt((B(3)-B(4))^2+B(5)^2)+(B(3)-B(2))+(B(4)-B(1));

minmax=(min(P_A,P_B)+min(A(5),B(5)))/(max(P_A,P_B)+max(A(5),B(5)));
S1=1-sum(abs(A(1:4)-B(1:4)))/4;
Simil=S1*minmax;



