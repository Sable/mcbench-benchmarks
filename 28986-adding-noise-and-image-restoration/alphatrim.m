function f = alphatrim(g,m,n,d)
% implements a alpha-trimmed mean filter.
inclass = class(g);
g = im2double(g);
f = ordfilt2(g,1,ones(m,n),'symmetric');
for k = 1:d/2
    f = imsubstract(f,ordfilt2(g,k,ones(m,n),'symmetric'));
end
for k = (m*n + (d/2) + 1):m*n
    f = imsubstract(f,ordfilt2(g,k,ones(m,n),'symmetric'));
end
f = f/(m*n - d);
f = changeclass(inclass,f);