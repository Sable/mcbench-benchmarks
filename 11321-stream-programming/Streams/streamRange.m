function vals = streamRange(s,start,nElem)
% STREAMRANGE  Cut a range of a stream
s1 = s;
for i=1:start-1
    s1 = streamCdr(s1);
end
vals = cell(1,nElem);
for i=1:nElem
    vals{i} = streamCar(s1);
    s1 = streamCdr(s1);
end
