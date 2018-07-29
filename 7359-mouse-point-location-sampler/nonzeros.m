function out=nonzeros(M)

% out collects the non-zero columns of M

[row columns] = size(M);

t=1;
for k=1:columns
    if (sum(M(:,k)))
        out(:,t)=M(:,k);
        t=t+1;
    end
end