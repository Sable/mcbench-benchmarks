function im = imscale(im,scl)
if nargin < 2
    scl = 255;
end
m_max = max(im(:));
m_min = min(im(:));
im = (im-m_min)/(m_max-m_min)*scl;
end
