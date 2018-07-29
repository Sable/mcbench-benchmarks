

function Sigma_Vector=Sigma_i(index,M,N)


for k=0:N-1
    temp(k+1)=exp(j*2*pi*index*k/M);
end

Sigma_Vector=temp;