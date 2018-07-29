% Question No: 7

% Given an image. Implement the split and merge procedure for segmenting
% the image with different values for minimum dimensions of the quadtree
% regions.

function quadtree(x)
f=imread(x);
q=2^nextpow2(max(size(f)));
[m n]=size(f);
f=padarray(f,[q-m,q-n],'post');
mindim=2;
s=qtdecomp(f,@split,mindim,@predicate);
lmax=full(max(s(:)));
g=zeros(size(f));
marker=zeros(size(f));
for k=1:lmax
    [vals,r,c]=qtgetblk(f,s,k);
    if ~isempty(vals)
        for i=1:length(r)
            xlow=r(i);ylow=c(i);
            xhigh=xlow+k-1;
            yhigh=ylow+k-1;
            region=f(xlow:xhigh,ylow:yhigh);
            flag=feval(@predicate,region);
            if flag
                 g(xlow:xhigh,ylow:yhigh)=1;
                 marker(xlow,ylow)=1;
            end
        end
    end
end
g=bwlabel(imreconstruct(marker,g));
g=g(1:m,1:n);
f=f(1:m,1:n);
figure, imshow(f),title('Original Image');
figure, imshow(g),title('Segmented Image');
end

function v=split(b,mindim,fun)
k=size(b,3);
v(1:k)=false;
for i=1:k
    quadrgn=b(:,:,i);
    if size(quadrgn,1)<=mindim
        v(i)=false;
        continue;
    end
    flag=feval(fun,quadrgn);
    if flag
        v(i)=true;
    end
end
end

function flag=predicate(region)
sd=std2(region);
m=mean2(region);
flag=(sd>5)&(m>0)&(m<200);
end