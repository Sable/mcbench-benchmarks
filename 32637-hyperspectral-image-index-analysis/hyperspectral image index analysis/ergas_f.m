function [ergas_pb av_ergas ergas_tl] = ergas_f(x,y,resratio)

% ERGAS calculator

% 19/08/2009 Version 1.0
% 02/12/2009 Version 1.5    - hyperspectral support
% 05/03/2010 Version 2.0    - Double precision, RAM efficiency
% 07/03/2010 Version 3.0    - Progressbar
% 07/08/2011 Version 3.0F   - Function Version

% Author: Aristidis D. Vaiopoulos

%Find the number of bands
sizi = size(x);
if max(size(size(x))) == 2
    bands = 1;
else
    bands = sizi(1,3);
end

%RMSE part
nres = sizi(1,1)*sizi(1,2);

%Variable preallocation
meansx  = zeros(bands,1);           
%meansy  = zeros(bands,1);           
RMSE = zeros(bands,1);

for i = 1:bands                     
    xt = double(x(:,:,i));          
    yt = double(y(:,:,i));          
    %Mean value calculation for ERGAS
    meansx(i,1) = mean(xt(:));
    %meansy(i,1) = mean(yt(:));
    %RMSE
    RMSE(i) = sqrt((sum(sum((xt - yt).^2)))/nres); 
end

%End of RMSE part

%ERGAS part
presratio = 100*resratio;
ergasroot = sqrt(  (RMSE.^2)./(meansx.^2)   );
ergas_pb  = presratio*ergasroot;
av_ergas  = mean(ergas_pb);
ergasroot = sqrt((sum((RMSE.^2)./(meansx.^2))) / bands);
ergas_tl  = presratio*ergasroot;

end