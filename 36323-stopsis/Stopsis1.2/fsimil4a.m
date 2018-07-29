function [Simil4]=fuzzysimil4(A,B)

if A(1)==A(4)
    Ya=A(5)/2;
else
    Ya=A(5)*((A(3)-A(2))/(A(4)-A(1))+2);
end
if B(1)==B(4)
    Yb=B(5)/2;
else
    Yb=B(5)*((B(3)-B(2))/(B(4)-B(1))+2);
end
Xa=(Ya*(A(3)+A(2))+(A(4)+A(1))*(A(5)-Ya))/2*A(5);
Xb=(Yb*(B(3)+B(2))+(B(4)+B(1))*(B(5)-Yb))/2*B(5);
Sa=A(4)-A(1);
Sb=B(4)-B(1);
if (Sa+Sb)/2==0
    sasb=0;
else
    sasb=1;
end
temp=(1-abs(Xa-Xb))^(sasb)*min(Ya,Yb)/max(Ya,Yb);
S1=1-sum(abs(A(1:4)-B(1:4)))/4;
Simil4=S1*temp;

