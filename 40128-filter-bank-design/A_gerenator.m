


function A=A_gerenator(x,Beta,Sigma_dictionary,M)


[m,n]=size(x);
index_column=0;

for i=1:m
    temp_h=x(i,:);
    
    index_row=0;
    for k=1:M
        temp_A(1+index_row:2*n-1+index_row,1+index_column:n+index_column)=Beta(k,i)*filter_bank_operater(Sigma_dictionary(k,:).*temp_h);
        index_row=index_row+2*n-1;
    end
    
    index_column=index_column+n;
    
end
    

A=temp_A;
