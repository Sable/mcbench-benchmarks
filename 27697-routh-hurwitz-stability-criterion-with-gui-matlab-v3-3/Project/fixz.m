function [T]=fixz(M,C)
%out=fixz(Matrix,confine)
%
%confine is nonzero positive Integer number
%these function set amount all element of a matrix to zero if respective
%array is  -confine=<M(i,j)<=confine
%
%for example: confine=5 produce precision 0.00001
%and all array input Matrix check ==>  -0.00001=<M(i,j)<=0.00001
%if respective array is in this confine then that array equal zero
cstr='0.';
for k=3:C+1
    cstr(k)='0';
end
if C==1
    k=2;
end
cstr(k+1)='1';    
cdo=str2double(cstr);

[m,n]=size(M);
for i=1:m
    for j=1:n
        if isreal(M(i,j))
            if M(i,j)<=cdo && M(i,j)>=-cdo
                M(i,j)=fix(M(i,j));
            end
        else
            re=real(M(i,j));
            im=imag(M(i,j));
            if re<=cdo && re>=-cdo
                re=fix(re);
            elseif im<=cdo && im>=-cdo
                im=fix(im);
            end
            M(i,j)=complex(re,im);
        end
    end
end
T=M;