function [rase_pb av_rase rase_tl] = rase_f(x,y)

% RASE calculator

% 21/08/2009 Version 1.0
% 02/12/2009 Version 1.5    - hyperspectral support
% 05/03/2010 Version 2.0    - Double precision, RAM efficiency
% 08/08/2011 Version 2.2F   - Function Version

% Author: Aristidis D. Vaiopoulos

% RMSE part

% Find the number of bands
sizi = size(x);
if max(size(size(x))) == 2
    bands = 1;
else
    bands = sizi(1,3);
end
nres = sizi(1,1)*sizi(1,2);

% Preallocation
rmses = zeros(bands,1); 
Ms   = zeros(bands,1);
for i = 1:bands             
    xt = double(x(:,:,i));  
    yt = double(y(:,:,i)); 
    rmses(i) = sqrt((sum(sum((xt - yt).^2)))/nres);
    % Mean xs for RASE
    Ms(i)      = mean2(x(:,:,i));
end
% End of RMSE part

% RASE part
rmsesquared = rmses.^2;
srmsesq     = sum(rmsesquared);
M           = mean(x(:));
% Total RASE
rase_tl     = (100/M)*(sqrt(srmsesq/bands));
% RASE per band
rase_pb     = (100./Ms).*sqrt(rmsesquared);
% Average RASE
av_rase     = mean(rase_pb);
% End of RASE part

end


