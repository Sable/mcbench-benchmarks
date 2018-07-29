% function Img = generate_correlated_image (ImSize,rho,sigma,muImg,covfunc)
% -This function generates images with spatially correlated pixels.
% It regards an image as a discerete random field where each pixel is a
% random variable. The pixels can be correlated or completely independent,white noise field.
% -Using uImg one can generate images with such as Beta, gamma, Weibull, Poisson
% distribution by simply using inverse pdf function; for instance, pImg = poissinv(uImg)
%  Inputs:
%   ImgSize :   [row col]
%   rho     :   A number between 0 and 1.0 ( 0 no correlation and 1 maximum
%               correlation
%               The covariance function is defined as covmatrix= sigma*rho.^(d) where d 
%               is the euclidean distance between pixels
%   sigma   :   sigma of the normal distribution
%   muImg   :   This is the mean image specifying the mean value for each pixel
%  Output: 
%   Img     :   Output image
%   Example :   [nImg,uImg] = generate_correlated_image ([32 32],0.95,5,zeros(32,32));
% Written by Omer Demirkaya Jan 2004.

function [nImg,uImg] = generate_correlated_image (ImSize,rho,sigma,muImg)
if prod(size(muImg)) ~= prod(ImSize)
    printf(1,'Mean image (muImg) has to have the same dimensions');
    return;
end;
[r,c] = find(ones(ImSize));
d = squareform(pdist([r c],'euclidean'));
muvec = muImg(:);
covmat = sigma*rho.^d;
nImg = reshape(mvnrnd(muvec,covmat,1),ImSize);
uImg = normcdf(nImg);
