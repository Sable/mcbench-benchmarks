function [rmses, av_rmse] = rmse_f(x,y)

% RMSE calculator

% 02/12/2009 Version 1.5    - Hyperspectral support
% 05/03/2010 Version 2.0    - Double precision, RAM efficiency
% 25/06/2010 Version 2.2    - Excel Output option
% 08/08/2011 Version 2.4F   - Function Version

% Author: Aristidis D. Vaiopoulos

sizi = size(x);
if max(size(size(x))) == 2
    bands = 1;
else
    bands = sizi(1,3);
end

nres = sizi(1,1)*sizi(1,2);

rmses = zeros(bands,1);
for i = 1:bands             
    xt = double(x(:,:,i));  
    yt = double(y(:,:,i));  
    rmses(i) = sqrt( (sum(sum((xt - yt).^2)))/nres );
end

av_rmse = mean(rmses);

end

