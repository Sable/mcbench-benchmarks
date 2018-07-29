function ShowCurveletFilters(mfb)

%=======================================================================
% function ShowCurveletFilters(mfb)
% 
% This function displays the curvelet filter bank (one figure per scale)
%
% Inputs:
%   -mfb: the curvelet filter banks to display
%
% Author: Jerome Gilles
% Institution: UCLA - Department of Mathematics
% Year: 2013
% Version: 1.0
%=======================================================================

Ns=length(mfb);

% Show the low pass filter
figure;
imshow(fftshift(abs(mfb{1})),[]);
%imshow(abs(mfb{1}),[]);

for s=2:Ns
   Nt=length(mfb{s});
   figure;
   for t=1:Nt
      subplot(1,Nt,t);
      imshow(fftshift(abs(mfb{s}{t})),[]);
%      imshow(abs(mfb{s}{t}),[]);
   end
end
