function vals = streamHead(s,n)
% STREAMHEAD  Compute the first n elements of the stream
s1 = s;
vals = cell(1,n);
for i=1:n
    vals{i} = streamCar(s1);
    s1 = streamCdr(s1);
end
