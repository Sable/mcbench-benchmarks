function [qs av_q cc av_cc] = q_f(x,y)

% Q index
% Universal image quality calculator

% 11/08/2009 Version 1.0
% 02/12/2009 Version 1.5    - Hyperspectral support
% 05/12/2010 Version 3.0    - Double precision, RAM efficiency, Progressbar
% 25/06/2010 Version 3.2    - Excel Output option
% 07/08/2011 Version 3.4F   - Function Version

% Author: Aristidis D. Vaiopoulos

% Find number of bands
bands = size(x);
if length(bands) == 3
    bands = bands(1,3);
else
    bands = 1;
end

% Preallocation
meansx = zeros(bands,1);
meansy = zeros(bands,1);
sdsx   = zeros(bands,1);
sdsy   = zeros(bands,1);
cc     = zeros(bands,1);

for i = 1:bands;    
    xt = double(x(:,:,i));
    yt = double(y(:,:,i));
    % Statistics for each band
    meansx(i) = mean(xt(:));
    meansy(i) = mean(yt(:));
    sdsx(i)   = std2(xt);
    sdsy(i)   = std2(yt);
    % Correlation Coefficient for each band
    cc(i) = corr2(xt,yt);
end

% Quality for each band
qs = (  ( cc .* ( (2.*meansx.*meansy) ./ (meansx.^2 + meansy.^2)  ) ...
             .* ( (2.*sdsx  .*sdsy  ) ./ (sdsx.^2 + sdsy.^2) ) )  ) ;    

% Calculate mean quality and mean correlation coefficient
av_q  = mean(qs);
av_cc = mean(cc);

end






