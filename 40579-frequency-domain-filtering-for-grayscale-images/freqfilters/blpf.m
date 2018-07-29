function res = blpf(im,thresh,n)

% inputs
% im is the fourier transform of the image
% thresh is the cutoff circle radius (1,2,3...)
% n is the order of the filter (1,2,3...)

%outputs
% res is the filtered image

[r,c]=size(im);
d0=thresh;

d=zeros(r,c);
h=zeros(r,c);

for i=1:r
    for j=1:c
     d(i,j)=  sqrt( (i-(r/2))^2 + (j-(c/2))^2);
    end
end

for i=1:r
    for j=1:c
      h(i,j)=  1 / (1+ (d(i,j)/d0)^(2*n) ) ;
    end
end


for i=1:r
    for j=1:c
    res(i,j)=(h(i,j))*im(i,j);

    end
end




