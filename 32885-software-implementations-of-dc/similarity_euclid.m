function R= similarity_euclid(data)

nrow = size(data,1);
R=zeros(nrow,nrow);
data = data';
for i=1:nrow-1
    x=data(:,i);
    for j=i+1:nrow
        y=x-data(:,j);
        d=y'*y;
%       d=sqrt(d);
        R(i,j) = d;
        R(j,i) = d; 
    end 
end