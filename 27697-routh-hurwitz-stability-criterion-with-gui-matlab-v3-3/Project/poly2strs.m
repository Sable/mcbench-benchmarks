function [S]=poly2strs(P,C)
%poly2strs Return polynomial as string with mathematics sign(*,+,-).
%S=poly2strs(P,'s') or S=poly2strs(P,'z') returns a string S 
%consisting of the polynomial coefficients in the vector P 
%multiplied by powers of the transform variable 's' or 'z'.
%
%Example: poly2strs([4 0 2],'s') returns the string  '4*s^2+2'.

%Amin Heidari
%$Revision: 1.1 $  $Date: 2009/05/13 09:36:27 $
%Email:amin_heidari66@yahoo.com
str={};
q=length(P)-1;
for i=1:length(P)
    if q~=0
        if P(i)==0
            str{i}='';
        elseif q~=1
            str{i}=sprintf('%+g*%c^%g',P(i),C,q);
        elseif q==1
            str{i}=sprintf('%+g*%c',P(i),C);
        end
    elseif q==0
        if P(i)==0
            str{i}='';
        elseif P(i)~=0
            str{i}=sprintf('%+g',P(i));
        end
    end
    q=q-1;
end
b=strcat(str{:});
if b(1)=='+'
    b(1)=[];
end
len=length(b);
j=1;
while j<=len
    if b(j)=='*'
        if b(j-1)=='1'
            if j==2
                b(j)=[];
                b(j-1)=[];
                len=len-2;
            elseif j>2
                if isnumstr(b(j-2))==0 && b(j-2)~='.'
                    b(j)=[];
                    b(j-1)=[];
                    len=len-2;
                end
            end
        end
    end
    j=j+1;
end
S=b;

function [A]=isnumstr(I)
if I=='0' || I=='1' || I=='2' || I=='3' || I=='4' || I=='5'|| I=='6' || I=='7' || I=='8' || I=='9'
    A=true;
else
    A=false;
end
