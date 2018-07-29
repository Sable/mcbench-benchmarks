function fimg = dnlm(img, options)

% FIMG = DNLM(IMG, OPTIONS)
%
% Filters a 4D image using dynamic non-local means
%
%INPUT
% img is a 4D image
% options is a structure containing:
% options.k is a vector, holding the radius of the comparison window for each dimension
%           if a single value is used an isotropic window will be used
% options.sig is the estimated noise standard deviation. If not given it
%             will be automatically estimated using the method from "Noise Reduction for Magnetic Resonance Images via
%             Adaptive Multiscale Products Thresholding", Paul Bao, Lei Zhang, 2003.
% options.beta is the denoising factor. If not given, it will be set to be 1
%         note that h^2 = 2 * beta * sig^2 * n_of_neighbours (according to the similarity window size)
% options.dstsig is the std, in pixels, to use for distance weighting (default is max(k)/2)
% options.win is a vector , holding the size of search radius in each dimension
%           if a single value is used an isotropic search area will be used
% options.ancor is a scalar, 1 for classic NL-Means, 2 (default) for DNLM
%               ancor=0 will use DNLM without noise thresholding (i.e. will denoise even differences smaller than sig)
%
%OUTPUT
% A denoised image
%
% Author: Yaniv Gal, The University of Queensland, 2009
%
% Reference: Yaniv Gal, Andrew Mehnert, Andrew Bradley, Kerry McMahon, Dominic Kennedy, and Stuart Crozier, 
%            “Denoising of Dynamic Contrast-Enhanced MR Images Using Dynamic Non-Local Means”, 
%            IEEE Transactions on Medical Imaging, vol. 29(2), p.302-310, 2010

size_x = size(img,1);
size_y = size(img,2);
size_z = size(img,3);
size_w = size(img,4);

fimg = zeros(size_x, size_y, size_z, size_w);

if length(options.k) == 1
    k = [options.k options.k options.k options.k];
else
    k = options.k;
end

if isfield(options, 'dstsig')
    dst_sig2 = options.dstsig * options.dstsig;
else
    dst_sig2 = max(k)*max(k)/4;
end

if isfield(options, 'ancor')
    ancor = options.ancor; % 0=Old DNLM, 1=ENLM, 2=New DNLM
else
    ancor = 2; % new DNLM
end

if isfield(options, 'win')
    if length(options.win) == 1
        win = [options.win options.win options.win options.win];
    else
        win = options.win;
    end
else
    win = [0 0 0 size(img,4)];
end

if isfield(options, 'sig')
    sig = options.sig;
else
    est_noise = 0;
    est_count = 0;
    for w=1:size_w
        for z=1:size_z
            [~, ~, est_MAV] = estimate_noise_dwt(img(:,:,z,w));
            est_noise = est_noise + est_MAV;
            est_count = est_count + 1;
        end
    end
    sig = est_noise / est_count;
end

if isfield(options, 'beta')
    sig2 = 2 * options.beta * sig * sig * (prod(2*k+1)-1); % = 2 * beta * noise^2 * n_of_neighbours
else
    sig2 = 2 * sig * sig * (prod(2*k+1)-1); % = 2 * noise^2 * n_of_neighbours
end

% Zero padding
size_px = size_x + 2 * k(1);
size_py = size_y + 2 * k(2);
size_pz = size_z + 2 * k(3);
size_pw = size_w + 2 * k(4);
pimg = zeros(size_px, size_py, size_pz, size_pw);
pimg((k(1)+1):(k(1)+size_x),(k(2)+1):(k(2)+size_y),(k(3)+1):(k(3)+size_z),(k(4)+1):(k(4)+size_w))=img;

% Building a distance Gaussian filter
dist_flt = zeros(k(1)*2+1, k(2)*2+1, k(3)*2+1, k(4)*2+1);
for wx=1:(k(1)*2+1)
    for wy=1:(k(2)*2+1)
        for wz=1:(k(3)*2+1)
            for ww=1:(k(4)*2+1)
                dst = norm([wx-k(1)-1 wy-k(2)-1 wz-k(3)-1 ww-k(4)-1]);
                dist_flt(wx,wy,wz,ww)=exp(-dst*dst/dst_sig2);
            end
        end
    end
end
dist_flt(k(1)+1,k(2)+1,k(3)+1,k(4)+1)=dist_flt(k(1),k(2)+1,k(3)+1,k(4)+1); % Reduce central weight to avoid over-weighting
dist_flt = dist_flt / sum(dist_flt(:));
%dist_flt = dist_flt / prod(2*k+1); % Normalise by number of pixels

% pixel external loops
for w=(k(4)+1):(k(4)+size_w)
    for z=(k(3)+1):(k(3)+size_z)
        for y=(k(2)+1):(k(2)+size_y)
            for x=(k(1)+1):(k(1)+size_x)
                pix_win = pimg((x-k(1)):(x+k(1)), (y-k(2)):(y+k(2)), (z-k(3)):(z+k(3)), (w-k(4)):(w+k(4)));
                mean_pix_win = mean(pix_win(:));
                win_len = length(pix_win(:));
                Zi = 0;
                Wval_sum = 0;
                
                % internal search loops
                for ww=max(w-win(4),k(4)+1):min(w+win(4),k(4)+size_w)
                    for zz=max(z-win(3),k(3)+1):min(z+win(3),k(3)+size_z)
                        for yy=max(y-win(2),k(2)+1):min(y+win(2),k(2)+size_y)
                            for xx=max(x-win(1),k(1)+1):min(x+win(1),k(1)+size_x)
                                comp_win = pimg((xx-k(1)):(xx+k(1)), (yy-k(2)):(yy+k(2)), (zz-k(3)):(zz+k(3)), (ww-k(4)):(ww+k(4)));
                                mean_comp_win = mean(comp_win(:));
                                if (mean_comp_win > 0)
                                    if ww ~= w && ancor ~= 1
                                    %if ww ~= w && ancor ~= 1 && 2*mean_pix_win/sig >= 3 && 2*mean_comp_win/sig >= 3
                                         diff_win = comp_win-pix_win;
                                         diff_mean = sum(abs(diff_win(:)))/win_len;
                                         if diff_mean > sig || ancor == 0 % old DNLM
                                            comp_win_factor = mean_pix_win / mean_comp_win; % original factor
                                            comp_win = comp_win * comp_win_factor;
                                         else
                                             comp_win_factor = 1;
                                         end
                                    else
                                        comp_win_factor = 1;
                                    end

                                    diff_win = comp_win-pix_win;
                                    diff_nrm2 = sum(dist_flt(:).*diff_win(:).*diff_win(:)); % norm2 convolved with a Gaussian
                                    nb_Wij = exp(-diff_nrm2/sig2);

                                    Zi = Zi + nb_Wij;
                                    Wval_sum = Wval_sum + (nb_Wij*pimg(xx,yy,zz,ww)*comp_win_factor);
                                end
                            end % closing internal search loops
                        end % closing internal search loops
                    end % closing internal search loops
                end % closing internal search loops

                if (Zi > 0)
                    fimg(x-k(1),y-k(2),z-k(3),w-k(4)) = Wval_sum / Zi; % normalising
                else
                    fimg(x-k(1),y-k(2),z-k(3),w-k(4)) = 0; % normalising
                end

            end % closing pixel external loops
        end % closing pixel external loops
    end % closing pixel external loops
end

