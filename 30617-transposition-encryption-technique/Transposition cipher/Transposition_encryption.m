function [cipher_data]=Transposition_encryption(N)
add='plain.txt';

 f_file = fopen(add, 'r');
 plain_txt = fscanf(f_file, '%c');
trans=zeros(N,N);
NN=N*N;
cipher_txt=[];
D=length(plain_txt);
pad=mod(D,NN);
plain_txt=[plain_txt zeros(1,pad)];
for r=1:length(plain_txt)/NN
       for s=1:NN
            trans(s)=plain_txt(s+NN*(r-1));
       end
        trans=trans';
        for q=1:NN
            cipher_txt=[cipher_txt trans(q)];
        end
end
cipher_data=char(cipher_txt);
f_file = fopen('trans_encryp.txt', 'w');
fprintf(f_file, '%c',cipher_data);