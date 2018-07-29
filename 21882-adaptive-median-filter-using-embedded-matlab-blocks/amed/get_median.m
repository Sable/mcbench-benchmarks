%#eml
function [min,med,max] = get_median(inbuf)

numpixels = length(inbuf);

tbuf = inbuf;

for ii=eml.unroll(1:numpixels)
    if bitand(ii,uint32(1)) == 1  
        tbuf = compare_stage1(tbuf);
    else
        tbuf = compare_stage2(tbuf);
    end
end

max = tbuf(1);
med = tbuf(ceil(numpixels/2));
min = tbuf(numpixels);

end

function outbuf = compare_stage1(inbuf)
numpixels = length(inbuf);
tbuf = compare_stage(inbuf(1:numpixels-1));
outbuf = [tbuf(:)' inbuf(numpixels)];
end

function outbuf = compare_stage2(inbuf)
numpixels = length(inbuf);
tbuf = compare_stage(inbuf(2:numpixels));
outbuf = [inbuf(1) tbuf(:)'];
end

function [outbuf] = compare_stage(inbuf)

step = 2;
numpixels = length(inbuf);

outbuf = inbuf;

for ii=eml.unroll(1:step:numpixels)
    t = compare_pixels([inbuf(ii), inbuf(ii+1)]);
    outbuf(ii) = t(1);
    outbuf(ii+1) = t(2);
end

end

function outbuf = compare_pixels(inbuf)
if (inbuf(1) > inbuf(2))
    outbuf = [inbuf(1), inbuf(2)];
else
    outbuf = [inbuf(2), inbuf(1)];
end
end
