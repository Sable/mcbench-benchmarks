function [div av_div] = div_f(x,y)

% DIV calculator
 %Difference In Variance 

% Formula: 1 - variance(fused image)/variance(original image)
% (Ideal value = 0)

% 07/03/2010 Version 1.0
% 25/06/2010 Version 1.2    -   Excel Output option
% 06/08/2011 Version 1.2F   -   Function version


% Author: Aristidis D. Vaiopoulos

%Find the number of bands
bands = size(x);
if length(bands) == 3
    bands = bands(1,3);
else
    bands = 1;
end
%Preallocation
sdx = zeros(bands,1);
sdy = zeros(bands,1);
%Standard deviations
for i = 1:bands
    xt = double(x(:,:,i));
    yt = double(y(:,:,i));
    sdx(i) = std2(xt);
    sdy(i) = std2(yt);
end

%Variance = (Standard deviation)^2
varx = sdx.^2;
vary = sdy.^2;
%Calculate DIV
div = 1 - (vary./varx);
%Average DIV
av_div = mean(div);

end
