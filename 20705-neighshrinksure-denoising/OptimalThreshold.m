function [guess,threshold] = OptimalThreshold(sub_coef,Rsim)
% Given the neighborhood size, compute an optimal threshold
% using NeighShrink SURE rule
%
% sub_coef: inputted noisy subband
% Rsim: neighborhood size
% guess: minimum risk
% threshold: outputted threshold
%
% Author: Zhou Dengwen
% zdw@ncepu.edu.cn
% Department of Computer Science & Technology
% North China Electric Power University(Beijing)(NCEPU)
%
% References:
% [1] Zhou Dengwen, Cheng Wengang, "Image denoising with an optimal
% threshold and neighbouring window," 
% Pattern Recognition Letters, vol.29, no.11, pp.1694¨C1697, 2008
%
% Last time modified: Jul. 15, 2008
%

%% Compute the subband size
[nRow,nCol] = size(sub_coef);
Ns = nRow*nCol; % subband length

%% Fill the noisy subband using zero
ext_sub_coef = padarray(sub_coef,[Rsim,Rsim],0);

%% Compute all S's and S2's of all neighborhoods
S = zeros(Ns,1); m = 0;
for j = Rsim+1:Rsim+nCol
    for i = Rsim+1:Rsim+nRow            
        ux = ext_sub_coef(i-Rsim:i+Rsim,j-Rsim:j+Rsim); % the neighborhood of the current pixel
        m = m + 1; S(m) = sum(ux(:).^2);      
    end
end
S2 = S.^2; tc2 = sub_coef(:).^2;

%% Produce the threshold vector
Thres = Rsim+1:0.1:(Rsim+1)*3;
%t1 = (2*Rsim+1)*log(nRow)/3; t2 = 2*(2*Rsim+1)*log(nRow);
%Thres = sqrt(t1):0.1:sqrt(t2);

%% Compute the threshold coresponding to the risk which is minimum
risk = zeros(1,length(Thres)); m = 0;
for th = Thres
        
    th2 = th*th; temp1 = 0; temp2 = 0; temp3 = 0;
    for k = 1:Ns
        if S(k) > th2
           temp1 = temp1 + 1/S(k)-2*tc2(k)/S2(k);
           temp2 = temp2 + tc2(k)/S2(k);
       else
           temp3 = temp3 + tc2(k)-2;
       end
   end
    m = m + 1; risk(m) = Ns-2*th2*temp1+th2*th2*temp2+temp3;
    
end

[guess,ibest] = min(risk);
threshold = Thres(ibest);