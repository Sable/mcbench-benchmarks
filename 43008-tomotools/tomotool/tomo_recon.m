function im_rec = tomo_recon(im,angles,method,n_it)
%TOMO_RECON   FBP, BP, MYART, SART
%
%   Phymhan
%   09-Aug-2013 10:19:03

switch nargin
    case 3
        n_it = 100;
    case 2
        method = 'fbp';
end
if strcmpi(method,'fbp')
    [projmat,~] = tomoproj2d(im,angles);
    im_rec = tomo_recon_fbp(projmat,angles);
elseif strcmpi(method,'bp')
    [projmat,~] = tomoproj2d(im,angles);
    im_rec = tomo_recon_bp(projmat,angles);
elseif strcmpi(method,'myart')
    im_rec = tomo_recon_myart_im(im,angles,n_it);
elseif strcmpi(method,'sart')
    im_rec = tomo_recon_sart_im(im,angles,n_it);
elseif strcmpi(method,'lsqr')
    im_rec = tomo_recon_lsqr_im(im,angles,1e-6,n_it);
else
    fprintf('Comming soon...\r')
    im_rec = [];
    return
end

%PREFERENCE:
%http://www.sv.vt.edu/xray_ct/parallel/Parallel_CT.html
%http://www.dspguide.com/ch25/5.htm
%http://www.owlnet.rice.edu/~elec539/Projects97/cult/node2.html
%http://www.owlnet.rice.edu/~elec539/Projects97/cult/node3.html#SECTION00021000000000000000
%http://www.owlnet.rice.edu/~elec539/Projects97/cult/node4.html#SECTION00022000000000000000
%http://en.wikipedia.org/wiki/Radon_transform
%http://en.wikipedia.org/wiki/Deconvolution
%http://www.tnw.tudelft.nl/index.php?id=33826&binary=/doc/mvanginkel_radonandhough_tr2004.pdf
