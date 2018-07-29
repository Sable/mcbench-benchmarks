function fitness=evaluate(position,k,N,D,L,var,x_max,fitness,Num_func)
for i=1:N
    for j=1:var
        temp=position(i,(j-1)*L+1:j*L);
        X(j)=decode(temp,L,x_max); %#ok<AGROW>
    end
    switch Num_func
        case 1
            result = sum (X.^2);
        case 2
            result = sum(abs(X)) + prod(abs(X)) ;
        case 3
            result = 0 ;
            for ii=1:var
                result = result + sum(X(1:ii)).^2;
            end
        case 4
            result = max (abs(X));
        case 5
            result = 0;
            for ii=1:var-1
                result = result + 100*((X(ii+1)-X(ii)^2)^2+(X(ii)-1)^2);
            end
    end
    fitness(i,k) = result ; 
end
return