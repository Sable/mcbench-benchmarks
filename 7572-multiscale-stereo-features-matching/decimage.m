function decim=decimage(im,M)
% IMAGE DECIMATION 
% LSS MATLAB WEBSERVER
[imysize,imxsize]=size(im);
decim = im([1:M:imysize],[1:M:imxsize]);