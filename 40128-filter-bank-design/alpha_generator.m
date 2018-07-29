


function Sigma_Vector=alpha_generator(l,M,nk)


if l==0 || l>M-1 || nk>M
    display('wrong input parameter')
    Sigma_Vector=[];
    return
end
    

flag_one=0;

for k=1:nk-1
    
    temp(k)=exp(j*2*pi*k/nk);
    if temp(k)==exp(j*2*pi*l/M)
        flag_one=1;
    end

end

 
if flag_one==0
    Sigma_Vector=0;
else
    Sigma_Vector=1;
end