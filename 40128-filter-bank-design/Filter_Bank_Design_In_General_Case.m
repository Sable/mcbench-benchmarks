

function error=Filter_Bank_Design_In_General_Case(x)


global Beta Sigma_dictionary M N K R gamma_cof cost_function_weight

optional_delay=0;

A=A_gerenator(x,Beta,Sigma_dictionary,M);
[m1,n1]=size(A);
b=zeros(m1,1);
b(N+optional_delay)=1;
Q=lscov(A,b);
error_pr=norm(A*Q-b);


for i=1:K
    temp_R=R{i};
    temp_gamma=gamma_cof{i}; 
    [m2,n2,l2]=size(temp_R);
    for k=1:l2
    temp_h(k)=norm(x(i,:)*temp_R(:,:,k)*x(i,:).'-temp_gamma(k)).^2;
    end   
    error_freqeuncey_temp(i)=sum(temp_h);
end
error_freqeuncey=sum(error_freqeuncey_temp);



error=cost_function_weight(1)*error_pr+cost_function_weight(2)*error_freqeuncey;