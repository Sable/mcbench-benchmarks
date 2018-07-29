function [Y]=j2sq(A)
%these function give a string and replace 'j' with 'sqrt(-1)'
%output is a string
%these function also place '*' if missed before 'j'
%
%for example:if input='(s-2j)*(s+2j)'
%then output='(s-2*sqrt(-1))*(s+2*sqrt(-1))'
i=1;
while i<=length(A)
    if A(1,i)=='j'
        if issignm(A(1,i-1))==0
            zone=A(1,i:length(A));
            A(i:length(A))='';
            A(1,i)='*';
            A=strcat(A,zone);
            i=i+1;
        end
        rep=A(1,i+1:length(A));
        A(i:length(A))='';
        A(1,i:i+7)='sqrt(-1)';
        A=strcat(A,rep);
        i=i+7;
    end
    i=i+1;
end
Y=A;

function [Q]=issignm(I)
%these function check input string
%if string is '+' or '-' or '*' or '/' then output is 1 else 0
if I=='+' || I=='-' || I=='*' || I=='/'
    Q=true;
else
    Q=false;
end