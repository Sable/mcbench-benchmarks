function [im_pad, imsize] = impad(im, padsize, immargin)
%IMPAD   [im_pad, mn] = impad(im, padsize)
%   Pad array, only support 2-D or 3-D matrix.
%   If padsize is not specified, the width as well as height of the padded
%   image equals the length of diagonal.
%
%   Phymhan
%   08-Aug-2013 16:51:42

[M,N,L] = size(im);
switch nargin
    case 3
        if ischar(padsize)
            padsize = 'diagonal';
        else
            if length(padsize) == 1
                padsize = [1 1 1]*padsize;
            end
        end
    case 2
        immargin = 0;
        if ischar(padsize)
            padsize = 'diagonal';
        else
            if length(padsize) == 1
                padsize = [1 1 1]*padsize;
            end
        end
    case 1
        immargin = 0;
        padsize = 'diagonal';
end
if L == 1 %2-D
    if strcmpi(padsize,'diagonal')
        D = ceil(sqrt(M^2+N^2))+2*immargin;
        M_pad = floor((D-M)/2);
        N_pad = floor((D-N)/2);
        m = D;
        n = D;
        imsize = D;
    else
        M_pad = ceil(padsize(1))+immargin;
        N_pad = ceil(padsize(2))+immargin;
        m = M+2*M_pad;
        n = N+2*N_pad;
        imsize = [m n];
    end
    im_pad = zeros(m,n);
    im_pad(M_pad+1:M_pad+M,N_pad+1:N_pad+N) = im;
else %3-D
    if strcmpi(padsize,'diagonal')
        D = ceil(sqrt(M^2+N^2+L^2))+2*immargin;
        M_pad = floor((D-M)/2);
        N_pad = floor((D-N)/2);
        L_pad = floor((D-L)/2);
        m = D;
        n = D;
        l = D;
        imsize = D;
    else
        M_pad = ceil(padsize(1))+immargin;
        N_pad = ceil(padsize(2))+immargin;
        L_pad = ceil(padsize(3))+immargin;
        m = M+2*M_pad;
        n = N+2*N_pad;
        l = L+2*L_pad;
        if L == 1
            imsize = [m n];
        else
            imsize = [m n l];
        end
    end
    im_pad = zeros(m,n,l);
    im_pad(M_pad+1:M_pad+M,N_pad+1:N_pad+N,L_pad+1:L_pad+L) = im;
end
end
