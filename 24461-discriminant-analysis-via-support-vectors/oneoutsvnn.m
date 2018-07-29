function total = oneoutsvnn(fea,gnd,k)
% total : Number of wrong classification samples
[N,d] = size(fea);
total = 0;
dd = zeros(N-1,1);
for num = 1:N;
    tri = zeros(N-1,d);
    tei = fea(num,:)/100;
    tel = gnd(num);
    tri(1:num-1,:) = fea(1:num-1,:)/100;
    trl(1:num-1,:) = gnd(1:num-1,:);
    tri(num:N-1,:) = fea(num+1:N,:)/100;
    trl(num:N-1,:) = gnd(num+1:N,:);
    V = SVDA(tri,trl,k);
    tri = tri*V;
    tei = tei*V;
    for i = 1:N-1;
        dd(i) = (tri(i,:)-tei)*(tri(i,:)-tei)';
    end;
    [p,index] = min(dd);
    if tel ~= trl(index);
        total = total+1;
    end;
end;