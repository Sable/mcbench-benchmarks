function K=kernel_RBF(Img,value)

% RBF-kernel parameters
a = 2;
b = 1;
sigma = .5;

sz=size(Img);

if length(sz)==3
    for k=1:3
        Kint(:,:,k)=Img(:,:,k)-value(k);
    end
    Kint=Kint.^a;
    Kint=squeeze(sum(Kint,3));
    K=exp(-Kint/sigma^2);
else
    K=exp(-(Img-value).^a/sigma^2);
end