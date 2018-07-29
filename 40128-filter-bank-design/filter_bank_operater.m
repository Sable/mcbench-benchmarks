


function output_vector=filter_bank_operater(input_vector)

N=length(input_vector);
temp=input_vector.';


temp_operator=zeros(2*N-1,N);
temp_operator(1:N,1)=temp;

for i=2:N
    temp_operator(:,i)=circshift(temp_operator(:,i-1),[1 0]);
end


output_vector=temp_operator;
