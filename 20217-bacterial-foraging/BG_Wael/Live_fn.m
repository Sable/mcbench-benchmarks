
function fposition=Live_fn(x)

    p=0;q=0;
    for k=1:5
    p=p+k*cos((k+1)*x(1)+k);
    q=q+k*cos((k+1)*x(2)+k);
    end

fposition=p*q+(x(1)+1.42513)^2+(x(2)+.80032)^2;
