function [cc av_cc] = ccc_f(x,y)

% Correlation Coefficient Calculator

% 07/03/2010 Version 1.0
% 25/06/2010 Version 1.2    - Excel Output option
% 04/08/2011 Version 1.2F   - Function Version

% Author: Aristidis D. Vaiopoulos

% Find the number of bands
bands = size(x);
if length(bands) == 3
    bands = bands(1,3);
else
    bands = 1;
end
% Preallocation
cc = zeros(bands,1);

% Correlation Coefficient calculation
for i = 1:bands
    xt = double(x(:,:,i));
    yt = double(y(:,:,i));
    cc(i) = corr2(xt,yt);    
end

% Average CC
av_cc = mean(cc);

end

