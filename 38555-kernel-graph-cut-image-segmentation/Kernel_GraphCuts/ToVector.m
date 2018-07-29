function v = ToVector(im)
sz = size(im);
if size(im,3)==3
    v = reshape(im, [prod(sz(1:2)) 3]);
else
    v = reshape(im, [prod(sz(1:2)) 1]);
end