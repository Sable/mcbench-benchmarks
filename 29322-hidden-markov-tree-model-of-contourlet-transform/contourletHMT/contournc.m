% contournc.m
% (abbreviation of contourlet Noise Covariance)
% written by: Duncan Po
% Date: January 14 /2004
% Usage: nc = contournc(nv, dim, pyrfilter, dirfilter, nlev, imdim)
% nc: noise variance in the contourlet domain
% nv: white noise variance in the image domain
% pyrfilter: pyramid filter for contourlet transform
% dirfilter: directional filter for contourlet transform
% nlev: partition scheme for contourlet transform
% imdim: image dimension (length of a side, square image is assumed)
% uses monte-carlo approach to determine the noise variance of image
% domain white noise in contourlet domain


function nc = contournc(nv, pyrfilter, dirfilter, nlev, imdim)

numtrial = 200;
for trial = 1:numtrial
    

noisepic = (255*sqrt(nv))*randn(imdim);
%figure;
%imshow(noisepic);
noisecontour = pdfbdec(noisepic, pyrfilter, dirfilter, nlev);
for scale = 2:length(noisecontour)
    n = [];
    for dir = 1:length(noisecontour{scale})
       if trial == 1
          nc{scale}{dir} = noisecontour{scale}{dir}...
             .*noisecontour{scale}{dir}/numtrial;
       else
          nc{scale}{dir} = nc{scale}{dir} + noisecontour{scale}{dir}...
             .*noisecontour{scale}{dir}/numtrial;
       end;
    end;
end;
end;
    





