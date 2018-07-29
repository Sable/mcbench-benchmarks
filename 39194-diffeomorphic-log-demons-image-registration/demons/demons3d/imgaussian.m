%% Apply gaussian filter to image
%  Changed: Dec 31st, 2011
%
function I = imgaussian(I,sigma)

    if sigma==0; return; end; % no smoothing
    
    if size(size(I))==4; I = imgaussian_multichannel(I,sigma); return; end;
    
    % Create Gaussian kernel
    radius   = ceil(3*sigma);
    [y,x,z]  = ndgrid(-radius:radius,-radius:radius,-radius:radius); % kernel coordinates
    h        = exp(-(x.^2 + y.^2 + z.^2)/(2*sigma^2));
    h        = h / sum(h(:));
    
    % Filter image
    I = imfilter(I,h);

end

%% Apply gaussian filter to image
%  Changed: Dec 31st, 2011
%
function I = imgaussian_multichannel(I,sigma)

    if sigma==0; return; end; % no smoothing
    
    nchannels = size(I,4);

    for i=1:nchannels
        Ip(:,:,:,i) = imgaussian(I(:,:,:,i),sigma);
    end
    
    I = Ip;

end

