function [ f ] = sft2_low( x, maxFreq, totalLen)
% SFT2_low Two-dimensional discrete Fourier Transform.
% Only calculates the transform for low frequencies, but uses high
% resolution.
%
% Example:
% x = rand(100,95);
% f = sft2_low(x,5,2^12);
% f = fftshift(f);
%
% WARNING: I'm not entirely sure that this is exactly correct.
%
% DM, Aug 2013
%

% we assume x is roughly square, and totalLen is power of 2
lenX = 2^nextpow2(max(size(x)));

k_list = [1:maxFreq * totalLen/lenX ...
          totalLen-maxFreq * totalLen/lenX+1:totalLen ] - 1;

[N_1,N_2] = size(x);
      
f = exp(-2*pi*1i/totalLen * k_list(:) * (0:N_2-1)) * x.'; %dim=2  
f = f * exp(-2*pi*1i/totalLen * (0:N_1-1)' * k_list(:)'); %dim=1
f = f.';

end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Slightly easier to understand version
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% lenX = 2^nextpow2(max(size(x)));
% k_list = [1:maxFreq * totalLen/lenX ...
%     totalLen-maxFreq * totalLen/lenX+1:totalLen ] - 1;
% f_temp = sft(x,totalLen,2,k_list);
% f = sft(f_temp,totalLen,1,k_list);
%
%
% function yt=sft(y, N_, dim, k_list)
% % Slow Fourier transform function
% 
%     if ~exist('dim','var') || isempty(dim)
%         dim = 1;
%     end
% 
%     N = size(y,dim);
% 
%     if ~exist('N_','var') || isempty(N_)
%         N_ = N;
%     end
%     
%     if ~exist('k_list','var') || isempty(k_list)
%         k_list = 0:N_-1;
%     end    
% 
%     if dim == 2
%         yt = exp(-2*pi*1i/N_ * k_list(:) * (0:N-1)) * y.';
%     else % dim==1
%         yt = y.' * exp(-2*pi*1i/N_ * (0:N-1)' * k_list(:)');
%     end
% 
%     yt = yt.';
% 
% end

