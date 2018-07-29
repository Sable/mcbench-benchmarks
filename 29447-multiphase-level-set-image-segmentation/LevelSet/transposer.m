function N=transposer(M)

S=size(M,3);
if S==1
    N=M';
else
    for i = 1:S
        N(:,:,i)=M(:,:,i)';
    end
end

