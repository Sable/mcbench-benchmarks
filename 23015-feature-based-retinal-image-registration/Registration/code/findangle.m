function outdegs = findangle(boundvec, startidx)

% This function computes the bifurcation angle

npix = prod(size(boundvec));
if (sum(abs(boundvec))==0 | sum(abs(boundvec))== npix )
    outdegs =[];
    return;
end

% degree assignments
R  = npix/8;
dy = [0:1:R, R*ones(1, 2*R-1), R:-1:-R, -R* ones(1,2*R-1), -R:1:-1];
dx = [R*ones(1, R+1), R-1:-1:-R+1, -R*ones(1, 2*R+1), -R+1:1:R-1, R*ones(1, R)];
degs = atan2(dy, dx)*180/pi;
degs(degs<0) = degs(degs<0) + 360;

% find connected region
[labelmap, numlabel] = bwlabel(boundvec, 8);
if (boundvec(1)==1 & boundvec(end)==1)
    degs(labelmap == labelmap(end)) = degs(labelmap == labelmap(end))-360;
    labelmap(labelmap == labelmap(end)) = labelmap(1);
    numlabel= numlabel-1;
end

% angle assign to each region
for k=1:numlabel
    seeds = sort(degs(labelmap==k));
    m(k) = (seeds(1)+seeds(end))/2;
end
m(m<0) = m(m<0)+360;

for k = 1:numlabel-1
    outdegs(k)  = m(k+1)-m(k);
end
outdegs(numlabel)= m(1)-m(numlabel);
outdegs(outdegs<0) = outdegs(outdegs<0)+360;

% circulate the startidx to the first one
if (nargin == 2)
    while (boundvec(startidx)==0)
        startidx = startidx+1;
        if (startidx>npix)
            startidx = 1;
        end
    end
    outdegs = circshift(outdegs, [0, -labelmap(startidx)+1]);
end