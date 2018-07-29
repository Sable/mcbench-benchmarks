function [O]=titgen(S)
%these function give a string for example from poly2strs.m and if power of
%if each element >=10 then place it between { }
%for example if input: s^11+s^10+s^9+1  then output is s^{11}+s^{10}+s^9+1
%these is used for title.m for power >=10

if isempty(S)
    display('Error: Input String is empty');
    return;
end

len=length(S);
pointer=0;
k=1;
for i=1:len
    if S(i)=='^'
        pointer(1,k)=i;
        k=k+1;
    end    
    if (S(i)=='+' || S(i)=='-') && i~=1
        pointer(1,k)=i;
        k=k+1;
    end
end
lp=length(pointer);
str{1}=S(1:pointer(1));
for j=1:lp
    if j~=lp
        str{j+1}=S(pointer(j)+1:pointer(j+1));
    end
end
str{j+1}=S(pointer(lp)+1:len);

for m=2:2:length(str)
    temp=str{m};
    if temp(length(temp))=='+'
        temp(length(temp))='';
        str{m}=temp;
        str{m+1}=strcat('+',str{m+1});
    elseif temp(length(temp))=='-'
        temp(length(temp))='';
        str{m}=temp;
        str{m+1}=strcat('-',str{m+1});
    end

    num_pow=str2double(str{m});
    if num_pow>=10
        str{m}=sprintf('{%g}',num_pow);
    end
end

O=strcat(str{:});

